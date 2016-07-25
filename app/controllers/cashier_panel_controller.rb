class CashierPanelController < ActionController::Base
  layout 'cashier_panel'

  before_action :authenticate_cashier!

  def sell_ticket
    @events = Event.all.order(datetime: :asc).where(IsActive: true)
    @ticket_count = TicketItem.where(is_invalid: false).count
    if params[:event_id]
      @event = Event.find(params[:event_id])
    end
  end

  def save_tickets
    permission = true

    interval = current_cashier.intervals.where({ active: true }).first

    if current_cashier.sell
      if params[:invitation]
        if current_cashier.invitation == false
          permission = false
        end
      end

      if params[:discount]
        if current_cashier.discount == false && params[:discount] > 100 && params[:discount] < 1
          permission = false
        end
      end
        event = Event.find(params[:event_id])
        seat_ids = SelectedPlace.where({ event_id: event.id, cashier_id: current_cashier.id})

      if(interval.interval_number + seat_ids.count) > interval.to
        permission = false
      end

        if permission
        if seat_ids.count > 0
          invoice = Invoice.new
          invoice.cashier_id = current_cashier.id
          invoice.event_id = event.id
          invoice.save

          saved_seats = []

          seat_ids.each do |place|
            seat = Seat.find(place.seat_id)
            pre_ticket = TicketItem.where({ event_id: event.id, seat_id: seat.id })
            unless pre_ticket.present?
              selling_seat = SellingSeat.where(seat_id: seat.id, event_id: event.id).first
              ticket = TicketItem.new
              ticket.cashier_id = current_cashier.id
              ticket.event_id = params[:event_id]
              ticket.seat_id = seat.id
              ticket.invoice_id = invoice.id
              ticket.interval_number = interval.interval_number
              ticket.entrance = Entrance.where({ event_id: event.id, sector_id: seat.sector.id }).first.entrance_text
              ticket.sector = seat.real_sector_id
              ticket.row = seat.real_row
              ticket.column = seat.real_column
              ticket.real_price = selling_seat.price
              selling_seat.price = 0 if params[:invitation]
              selling_seat.price = (selling_seat.price * ( 100 - params[:percent].to_i) / 100).round(2) if params[:discount]
              ticket.price = selling_seat.price
              selling_seat.ticket_type.name = 'invitation' if params[:invitation]
              selling_seat.ticket_type.name = 'discount' if params[:discount]
              ticket.ticket_type = selling_seat.ticket_type.name
              ticket.ticket_image = selling_seat.ticket_type.image_url
              ticket.seat_sector_id = seat.sector_id

              ticket.save
              bron = BronTicket.where({ event_id: event.id, seat_id: seat.id }).where("created_at <= ? AND expiry_date >= ?", DateTime.now, DateTime.now).first

              if bron.present?
                bron.expiry_date = DateTime.now
                bron.closed_by = current_cashier.id
                bron.save
              end
              interval.interval_number = interval.interval_number + 1
              interval.save
            end

            selected = SelectedPlace.where({ seat_id: seat.id, event_id: event.id }).first
            if selected
              selected.destroy
            end

            saved_seats.push(ticket.id)
          end

          render text: invoice.id
        else
          head status: :bad_request
        end
      else
        head status: :forbidden
      end
    else
      head status: :forbidden
    end

    # render text: invoice.id
  end


  def bron_tickets
    if current_cashier.bron
      event = Event.find(params[:event_id])
      seat_ids = SelectedPlace.where({ event_id: event.id, cashier_id: current_cashier.id})

      saved_seats = []
      seat_ids.each do |place|
        seat = Seat.find(place.seat_id)
        bron = BronTicket.where({ event_id: event.id, seat_id: seat.id }).where("created_at <= ? AND expiry_date >= ?", DateTime.now, DateTime.now).first
        if bron.present?
          bron.closed_by = current_cashier.id
          bron.expiry_date = Time.now
          bron.save
          saved_seats.push(bron.id)
        else
          ticket = BronTicket.new
          ticket.event_id = event.id
          ticket.opened_by = current_cashier.id
          ticket.seat_id = seat.id
          ticket.fullName = params[:name]
          ticket.seat_sector_id = seat.sector_id
          bron_days = params[:days].to_i
          bron_days = 1 if params[:days].blank?
          ticket.expiry_date = bron_days.days.from_now
          ticket.save

          saved_seats.push(ticket.id)
        end

        selected = SelectedPlace.where({ seat_id: seat.id, event_id: event.id }).first
        if selected
          selected.destroy
        end
      end

      render json: saved_seats
    else
      render text: 'You dont have permission to bron seats'
    end
  end

  def select_seat
    # seat_id = ActiveSupport::JSON.decode(params[:seat_id]).to_s
    seat = Seat.find(params[:seat_id])
    selected_place = SelectedPlace.new
    selected_place.cashier_id = current_cashier.id
    selected_place.event_id = params[:event_id]
    selected_place.seat_id = seat.id
    selected_place.seat_sector_id = seat.sector.id

    pre = SelectedPlace.where({ seat_id: selected_place.seat_id, event_id: selected_place.event_id })
    tickets = TicketItem.where({ seat_id: selected_place.seat_id, event_id: selected_place.event_id, cashier_id: selected_place.cashier_id, is_invalid: false })

    if pre.present?
      my_pre = pre.where({ cashier_id: selected_place.cashier_id }).first
      if my_pre.present?
        my_pre.destroy
        render :text => 'secilmis oturacaq legv edildi'
      else
        render :text => 'bu oturacagi basqasi secib', status: :conflict
      end
    else
      if tickets.present?
        render :text => 'bu oturacagi artiq alinib', status: :conflict
      else
        selected_place.save
        render :text => 'siz bunu secdiniz'
      end
    end
  end

  def unsell_seat
    if current_cashier.unsell
      # seat_id = ActiveSupport::JSON.decode(params[:seat_id]).to_s
      seat = Seat.find(params[:seat_id])

      tickets = TicketItem.where({ seat_id: params[:seat_id], event_id: params[:event_id]})

      if tickets.present?
        TicketItem.where({ seat_id: params[:seat_id], event_id: params[:event_id] }).delete_all
        render :text => 'bilet satisa qaytarildi'
      else
        render :text => 'geri qaytarmaq alinmadi', status: :conflict
      end
    end
  end

  def unavailable_seats
    event = Event.find(params[:event_id])
    sector = Sector.find(params[:sector_id])

    sold_seats = TicketItem.select(:seat_id).where({ event_id: event.id, seat_sector_id: sector.id, is_invalid: false })
    bron_seats = BronTicket.select(:seat_id).where({ event_id: event.id, seat_sector_id: sector.id }).where("created_at <= ? AND expiry_date >= ?", DateTime.now, DateTime.now)
    selected_seats = SelectedPlace.select(:seat_id).where({ event_id: event.id, seat_sector_id: sector.id }).where.not({ cashier_id: current_cashier.id })

    render :json => { metrics: { sold: sold_seats.count, bron: bron_seats.count }, sold_seats: sold_seats, selected_seats: selected_seats, bron_seats: bron_seats }
  end

  def my_selected_seats
    event = Event.find(params[:event_id])
    seats = []
    my_seats = SelectedPlace.where({ cashier_id: current_cashier.id, event_id: event.id })
    my_seats.each { |selected|
      selling_seat = SellingSeat.where({ event_id: event.id, seat_id: selected.seat.id }).first
      bron_seat = BronTicket.where({ event_id: event.id, seat_id: selected.seat.id }).first
      seats.push( selected_seat: selected, selling_seat: selling_seat, seat: selected.seat, bron_seat: bron_seat)
    }
    render json: seats
  end


  def bron_seats
    unavailable_seats = BronTicket.where({ event_id: params[:event_id] }).map(&:place)
    render :json => unavailable_seats
  end

  # def selected_seats
  #   render :json => unavailable_seats
  # end

  def my_tickets
    respond_to do |format|
      format.html
      format.json { render json: TicketItemDatatable.new(view_context) }
    end
  end

  def clear_selected
    event = Event.find(params[:event_id])
    my_seats = SelectedPlace.where({ cashier_id: current_cashier.id, event_id: event.id })
    my_seats.destroy_all
    render :json => { ok: "deleted" }
  end

  def invoice
    @invoice = Invoice.find(params[:id])
  end

  def report
    @events = Event.order(datetime: :asc)
    @ticket_items = TicketItem.where({ created_at: Time.now.beginning_of_day..Time.now, cashier_id: current_cashier.id, is_invalid: false })
    @bron_tickets = BronTicket.where({ created_at: Time.now.beginning_of_day..Time.now, opened_by: current_cashier.id })
  end

  def bron_seat

  end

  def invoices
    @invoices = Invoice.where({ cashier_id: current_cashier.id })
  end


  def show_seat_details
    seat = Seat.find(params[:seat_id])
    event = Event.find(params[:event_id])

    selling_seat = SellingSeat.where({ seat_id: seat.id, event_id: event.id }).first
    bron_seat = BronTicket.select("bron_tickets.*, cashiers.name as cashier_name").joins('INNER JOIN cashiers ON cashiers.id = bron_tickets.opened_by').where({ seat_id: seat.id, event_id: event.id }).where("bron_tickets.created_at <= ? AND bron_tickets.expiry_date >= ?", DateTime.now, DateTime.now).first

    render json: { seat: seat, selling_seat: selling_seat, bron_seat: bron_seat }
  end


  def show_sector_details
    sector = Sector.find(params[:sector_id])
    event = Event.find(params[:event_id])

    sold_seats = TicketItem.select(:seat_id).where({ event_id: event.id, seat_sector_id: sector.id, is_invalid: false }).count
    bron_seats = BronTicket.select(:seat_id).where({ event_id: event.id, seat_sector_id: sector.id }).where("created_at <= ? AND expiry_date >= ?", DateTime.now, DateTime.now).count
    selling_seat_count = 0
    seats = Seat.where({ sector_id: sector.id }).where.not( real_sector_id: "_")
    seats.each { |seat|
      selling_seat = SellingSeat.where({ event_id: event.id, seat_id: seat.id }).first
      if selling_seat
        selling_seat_count = selling_seat_count + 1;
      end
    }

    available_seats = selling_seat_count - sold_seats - bron_seats
    render json: { sold: sold_seats, bron: bron_seats, selling_seats: selling_seat_count, available_seats: available_seats }
  end
end