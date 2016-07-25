class StadiumController < ApplicationController
  layout 'main'

  def seat_map
    sector = Sector.find(params[:sector_id])
    event = Event.find(params[:event_id])
    seats = Seat.where({ sector_id: sector.id }).order(row: :asc, column: :asc)
    # seats = Seat.all
    max_row = seats.maximum(:row)
    max_col = seats.maximum(:column)
    seat_map = []

    counter = 0
    rows = ""
    for i in 0..max_row do
      one_row = ''
      for j in 0..max_col do
        if seats[counter]
          if (rows.include?(seats[counter].real_row.to_s)) == false and (seats[counter].real_row.to_s == '_') == false
            rows += seats[counter].real_row.to_s
          end
          if seats[counter].row == i and seats[counter].column == j
            if seats[counter].real_sector_id == '_'
              one_row += '_'
            else
              selling_seat = SellingSeat.where({ seat_id: seats[counter].id, event_id: event.id }).first
              if selling_seat
                one_row += selling_seat.color.identificator + '[' + seats[counter].id.to_s + ',' + seats[counter].real_column + ']'
              else
                one_row += 'o' + '[' + seats[counter].id.to_s + ',' + seats[counter].real_column + ']'
              end
            end
            counter = counter + 1
          else
            one_row += '_'
          end
        end
      end
      seat_map.push(one_row)
    end


    # rows = "RQPONMLKJIHG]"

    response = { sector: sector, seat_map: seat_map, rows: rows }
    render json: response

  end
end