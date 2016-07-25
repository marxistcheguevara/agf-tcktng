json.array!(@ticket_items) do |ticket_item|
  json.extract! ticket_item, :id
  json.url ticket_item_url(ticket_item, format: :json)
end
