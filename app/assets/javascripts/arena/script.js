$focused_sector_id = 0;
$(document).ready(function () {
    var $cart = $('#selected-seats'),
        $counter = $('#counter'),
        $total = $('#total');

});



$(document).ready(function () {

    $('.arena, .section').click(function(){
        $('div.sector').html('');
        $('.sNumb').fadeIn('slow');
        $('.sector').removeClass('zindex');
        $focused_sector_id = 0;
		$.post( "/cashier/clearSelected", { event_id: $event_id })
        $.post( "/cashier/clearSelected", { event_id: $event_id })
            .done(function( data ) {
                $sc.find('selected').status('available');
                updateCounter();
            })
            .error(function(data){
                alert('error')
            });
    })

    $('div.sector').hover(function(){
        $focused_sector = $(this);
        if($(this).data("sector-id") != undefined){
            jQuery.get("/cashier/showSectorDetails/" + $event_id + '/' + $(this).data("sector-id"))
                .done(function(data)
             {
               $focused_sector.attr( 'title', 'Satılıb: ' + data.sold + ', Bron: ' + data.bron + ', Boş: ' + data.available_seats );
             })
        }
    });




    $('div.sector').click(function(){
        last_sector_id = $focused_sector_id;
        $focused_sector_id = $(this).attr("data-sector-id");
        $('.sNumb').hide();
        $('.sector').removeClass('zindex');
        $('.sector').not(this).addClass('zindex');
        if(last_sector_id != $focused_sector_id){
            $.post( "/cashier/clearSelected", { event_id: $event_id });
            $.post( "/cashier/clearSelected", { event_id: $event_id })
                .done(function( data ) {
                    $sc.find('selected').status('available');
                    updateCounter();
                    // TODO print
                })
                .error(function(data){
                    alert('error')
                });
            $('div.sector').html("");
            number = $(this).prev().html();
            $(this).html("<div class='sector-metrics'>Sektor :"+ number+"  Satılıb:  <span id='sector-sold'></span>  Bron:  <span id='sector-bron'></span> Boş:   <span id='sector-free'></span></div><div class=\"seat-map-" + $focused_sector_id + "\"></div>");
            jQuery.get('/seat_map/' + $focused_sector_id + "/" + $event_id).done(function(data){
                $sc = $('.seat-map-' + $focused_sector_id).seatCharts({
                    map: data.seat_map,
                    seats: {
                        o: { classes: 'gray' },
                        g: { classes: 'dark-green' }
                    },
                    naming: {
                        left: true,
                        top: false,
                        rows: data.rows
                    },
                    click:
                        function () {
                            $clickedSeat = this;
                            if ($clickedSeat.status() == 'available') {
                                cavab = 'available';
                                $.ajax({
                                    type: 'POST',
                                    url: "/cashier/select_seat",
                                    data: { seat_id: $clickedSeat.settings.id, event_id: $event_id },
                                    async:false
                                }).done(function(){
                                    $('#checkout-button').removeClass('hide');
                                    $('#bron-button').removeClass('hide');
                                    cavab = 'selected';
                                    updateCounter();
                                }).error(function(data){
                                    alert(data.responseText);
                                    cavab = 'available';
                                });

                                return cavab;
                            } else if ($clickedSeat.status() == 'selected') {

                                cavab = 'selected';
                                $.ajax({
                                    type: 'POST',
                                    url: "/cashier/select_seat",
                                    data: { seat_id: $clickedSeat.settings.id, event_id: $event_id },
                                    async:false
                                }).done(function(){
                                    cavab = 'available';

                                    updateCounter();
                                }).error(function(data){
                                    alert(data.responseText);
                                    cavab = 'selected';
                                });

                                return cavab;

                            } else if (this.status() == 'unavailable') {
                                //seat has been already booked
                                // TODO unsell booked if arena has unsell class
                                return 'unavailable';

                            } else {

                                if ($(".arena").hasClass("unsell")) {
                                    // TODO unsell
                                    alert($clickedSeat.settings.id);
                                    $.ajax({
                                        type: 'POST',
                                        url: "/cashier/unsell_seat",
                                        data: { seat_id: $clickedSeat.settings.id, event_id: $event_id },
                                        async:false
                                    }).done(function(){
                                        updateCounter();
                                    }).error(function(data){
                                        alert(data.responseText);
                                    });

                                }

                                return this.style();
                            }
                        },
                    focus  : function() {
                        $focused_seat = this;
                        if (this.status() == 'available') {
                            //if seat's available, it can be focused
                            jQuery.get("/cashier/showSeatDetails/" + $event_id + '/' + this.settings.id).done(function(data){
                                if(data.bron_seat != undefined)
                                {
                                    var day = data.bron_seat.expiry_date.split('T')[0].split('-')[2];
                                    var month = data.bron_seat.expiry_date.split('T')[0].split('-')[1];
                                    var year = data.bron_seat.expiry_date.split('T')[0].split('-')[0];
                                    var jsdate = day +'-'+ month+'-'+ year;
                                    $focused_seat.node().attr('title', 'Qiymət: ' + data.selling_seat.price +' AZN, Bron: ' +  data.bron_seat.fullName +', Bitmə: '+  jsdate + ' Kassir: '+ data.bron_seat.cashier_name );
                                }
                                else
                                {
                                    $focused_seat.node().attr('title', 'Qiymət: ' + data.selling_seat.price +' AZN');
                                }


                            });

                            return 'focused';
                        } else  {
                            //otherwise nothing changes
                            return this.style();
                        }
                    }
                });
                $sc.find('o').status('disabled');
            });
        }
    });

    // Long Polling (Recommened Technique - Creates An Open Connection To Server ∴ Fast)
    setInterval(function() {
        if($focused_sector_id != 0) {
            $.get( '/cashier/unavailable_seats/' + $event_id + '/' + $focused_sector_id,
                function(data) {
                    $sc.find('available').node().removeClass("bron");
                    $sc.find('busy').status('available');
                    $sc.find('sold').status('available');
                    var sold_seats =  $.map(data.sold_seats, function(val) { return val.seat_id; });
                    var busy_seats =  $.map(data.selected_seats, function(val) { return val.seat_id; });
                    var bron_seats =  $.map(data.bron_seats, function(val) { return val.seat_id; });
                    $sc.status(sold_seats, 'sold');
                    $sc.status(busy_seats, 'busy');
                    $sc.get(bron_seats).node().addClass("bron");

                    $('#sector-sold').html(data.metrics.sold);
                    $('#sector-bron').html(data.metrics.bron);

                    $('#sector-free').html($sc.find('available').length - data.metrics.bron + $sc.find('selected').length );

                }
            )
        }
    }, 500);

});


