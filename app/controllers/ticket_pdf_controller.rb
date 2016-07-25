class TicketPdfController < ActionController::Base
  layout 'pdf'
  before_action :authenticate_cashier!

  def show
    @ticket = TicketItem.find(params[:id])


    barcode = Barby::Code128B.new(@ticket.seat_id.to_s + '_' + @ticket.event_id.to_s)
    @barcode = barcode.to_image(height: 55, margin: 5, xdim: 1).to_data_url
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: 'show',
               :margin => { :top => 0, :bottom => 10, :left => 10, :right => 10 } # Excluding ".pdf" extension.
      end
    end
  end

  def invoice
    @invoice = Invoice.find(params[:id])

    @invoice.ticket_items.sort_by { |ticket| [ ticket.seat.real_row, ticket.seat.real_column] }
    @barcodes = []
    @entrances = []

    @invoice.ticket_items.each do |ticket|
      barcode = Barby::Code128B.new(ticket.seat_id.to_s + '_' + ticket.event_id.to_s)
      @barcodes.push(barcode.to_image(height: 40, margin: 5, xdim: 1).to_data_url)
    end

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: 'invoice',
               :margin => { :top => 0, :bottom => 10, :left => 10, :right => 10 },
               :page_size => 'Letter',
               :page_width => 100,
               :page_height => 200
      end
    end
  end
end