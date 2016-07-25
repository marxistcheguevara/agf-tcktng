require "builder"
require "net/https"
require "uri"

class MainController < ApplicationController
  layout 'main'

  protect_from_forgery


  after_filter :set_csrf_cookie_for_ng

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  def index
    @competitions = Competition.where(IsActive: true)
    render 'pages/competitions'
  end

  def competition
    @competition = Competition.where(IsActive: true).find(params[:id])
    render 'pages/competition'
  end

  def buy_tickets
    @event = Event.where(IsActive: true).find(params[:event_id])
  end

  def event
    @event = Event.where(IsActive: true).find(params[:event_id])
  end


  def save_tickets
    cashier = Cashier.where({ name: 'online' }).first
    event = Event.where({ id: params[:event_id], IsActive: true }).first
    seat_ids = SelectedPlace.where({ event_id: event.id, cashier_id: cashier.id})
    if seat_ids.count > 0
      invoice = Invoice.new
      invoice.cashier_id = cashier.id
      invoice.save

      saved_seats = []

      seat_ids.each do |place|
        seat = Seat.find(place.seat_id)
        pre_ticket = TicketItem.where({ event_id: event.id, seat_id: seat.id })
        unless pre_ticket.present?
          selling_seat = SellingSeat.where(seat_id: seat.id, event_id: event.id).first
          ticket = TicketItem.new
          ticket.cashier_id = cashier.id
          ticket.event_id = params[:event_id]
          ticket.seat_id = seat.id
          ticket.invoice_id = invoice.id
          ticket.interval_number = 0
          ticket.entrance = Entrance.where({ event_id: event.id, sector_id: seat.sector.id }).first.entrance_text
          ticket.sector = seat.real_sector_id
          ticket.row = seat.real_row
          ticket.column = seat.real_column
          ticket.real_price = selling_seat.price
          ticket.price = selling_seat.price
          ticket.ticket_type = 'online'
          ticket.ticket_image = selling_seat.ticket_type.image_url
          ticket.seat_sector_id = seat.sector_id

          ticket.save
          bron = BronTicket.where({ event_id: event.id, seat_id: seat.id }).where("created_at <= ? AND expiry_date >= ?", DateTime.now, DateTime.now).first

          if bron.present?
            bron.expiry_date = DateTime.now
            bron.closed_by = cashier.id
            bron.save
          end
        end

        selected = SelectedPlace.where({ seat_id: seat.id, event_id: event.id }).first
        if selected
          selected.destroy
        end

        saved_seats.push(ticket.id)
      end

      total = invoice.ticket_items.sum(:price)
      c = ''
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.TKKPG {
          xml.Request {
            xml.Operation 'CreateOrder'
            xml.Language 'AZ'
            xml.Order {
              xml.Merchant 'E1000010'
              xml.Amount total
              xml.Currency '944'
              xml.Description '1'
              xml.ApproveURL 'http://ticketing.mga.az/online/approved'
              xml.CancelURL 'http://ticketing.mga.az/event/' + c
              xml.DeclineURL 'http://95.86.129.229:20300/event/' + c
            }
          }
        }
      end

      uri = URI.parse("https://e-commerce.kapitalbank.az:5443")

      header = { 'Content-Type' =>  'text/xml; charset=utf-8' }

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.key = OpenSSL::PKey::RSA.new(File.read("/home/agf/new_key/privkey.pem" ), "root00--")
      http.cert = OpenSSL::X509::Certificate.new(File.read("/home/agf/new_key/client.cer"))
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      req = Net::HTTP::Post.new('/Exec')
      req.body = builder.to_xml
      req.initialize_http_header(header)

      response = http.start do |sorgu|
          sorgu.request(req)
      end
      body = response.body

      render json: Hash.from_xml(body).to_json

    else
      render text: "seatIds sifir oldu"
    end
  end

  def sectors
    event = Event.where({ id: params[:event_id], IsActive: true }).first

    sectors = Sector.all.sort_by { |sector| sector.id}
    sector_details = []
    total_unavailable = 0
    total_available = 0
    sectors.each_with_index { |sector, index|
      sold_seats = TicketItem.select(:seat_id).where({ event_id: event.id, seat_sector_id: sector.id, is_invalid: false }).count
      bron_seats = BronTicket.select(:seat_id).where({ event_id: event.id, seat_sector_id: sector.id }).where("created_at <= ? AND expiry_date >= ?", DateTime.now, DateTime.now).count
      selected_seats = SelectedPlace.where({ event_id: event.id, seat_sector_id: sector.id }).count
      unavailable = sold_seats + bron_seats + selected_seats

      available = Seat.where({ sector_id: sector.id }).joins(:selling_seats).where('selling_seats.event_id' => event.id).count - unavailable

      total_unavailable = total_unavailable + unavailable
      total_available = total_available + available

      sector_details << { id: sector.id, name: sector.name, unavailable: unavailable, available: available}
    }

    render json: { sectors: sector_details, all: { unavailable: total_unavailable, available: total_available } }

  end

  def get_selling_seat
    seat = SellingSeat.where({ event_id: params[:event_id], seat_id: params[:seat_id] }).first
    render json: seat.to_json(:include => :seat)
  end

  def checkout_modal
    render "main/checkout_modal", :layout => false
  end

  def checkout
    selected_seats = params[:selected_seats]

    total = 0.00
    selected_seats.each { |selected_seat|
      selling_seat = SellingSeat.where({ event_id: params[:event_id], seat_id: selected_seat[:seat_id] }).first

      total = total + selling_seat.price
    }

    builder = Nokogiri::XML::Builder.new do |xml|
      xml.TKKPG {
        xml.Request {
          xml.Operation 'CreateOrder'
          xml.Language I18n.locale.upcase
          xml.Order {
            xml.Merchant 'E1000010'
            xml.Amount total * 100
            xml.Currency '944'
            xml.Description '1'
            xml.ApproveURL 'https://ticketing.mga.az/checkout/approved'
            xml.CancelURL 'https://ticketing.mga.az/checkout/cancelled'
            xml.DeclineURL 'https://ticketing.mga.az/checkout/success'
          }
        }
      }
    end

    uri = URI.parse("https://e-commerce.kapitalbank.az:5443")

    header = { 'Content-Type' =>  'text/xml; charset=utf-8' }

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.key = OpenSSL::PKey::RSA.new(File.read("/home/agf/new_key/privkey.pem" ), "root00--")
    http.cert = OpenSSL::X509::Certificate.new(File.read("/home/agf/new_key/client.cer"))
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    req = Net::HTTP::Post.new('/Exec')
    req.body = builder.to_xml
    req.initialize_http_header(header)

    response = http.start do |sorgu|
      sorgu.request(req)
    end
    body = response.body
    response_json = JSON.parse(Hash.from_xml(body).to_json,:symbolize_names => true)

    order = response_json[:TKKPG][:Response][:Order]

    checkout_url = order[:URL] + '?SESSIONID=' + order[:SessionID] + '&ORDERID=' + order[:OrderID]
    render json: { status: "Ok", url: checkout_url }
  end

  def approved

  end

  def terms

  end

  protected

  # In Rails 4.2 and above
  def verified_request?
    super || valid_authenticity_token?(session, request.headers['X-XSRF-TOKEN'])
  end

end
