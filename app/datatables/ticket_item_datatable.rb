class TicketItemDatatable < AjaxDatatablesRails::Base

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= [ 'id' ]
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= [  ]
  end

  private

  def data
    records.map do |record|
      [
          record.id,
          record.event.name,
          record.sector,
          record.row + record.column,
          record.price,
          record.ticket_type,
          record.created_at
      ]
    end
  end

  def get_raw_records
    TicketItem.all
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
