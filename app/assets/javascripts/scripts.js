
$(document).ready(function () {
    angular.module('mainApp', ['angularModalService', 'ui.bootstrap'])
        .controller('MainController', [ '$scope', '$uibModal', '$http', function($scope, $uibModal, $http) {

            $scope.total = 0;

            $http({
                method: "GET",
                url: "/online/" + $event_id + "/sectors"
            }).then(function (response) {
                console.log(response);
                $scope.sectors = response.data.sectors;
                $scope.allSectorsMetric = response.data.all;
                console.log($scope.sectors[24].available)
            });

            $scope.calculateTotal = function () {
                total = 0;
                $scope.selectedSeats.forEach(function (seat) {
                    total = total + seat.price;
                });
                $scope.total = total;
            };

            $('.arena, .section').click(function(){
                $('.sector').removeClass('zindex');
                $('.sNumb').fadeIn();
                $('.sector-metrics, .seatCharts-container').hide();
                $scope.selectedSeats = [];
                $scope.$apply();
            }); 

            $scope.checkout = function () {
                var modalInstance = $uibModal.open({
                    animation: true,
                    templateUrl: '/' + $scope.locale + '/buy-tickets/checkout-modal.html',
                    controller: 'CheckoutController',
                    size: 'lg',
                    resolve: {
                        seats: function () {
                            return $scope.selectedSeats;
                        },
                        event: function () {
                            return $event_id;
                        },
                        locale: function () {
                            return $scope.locale;
                        }
                    }
                });

                modalInstance.result.then(function (selectedItem) {
                    $scope.selected = selectedItem;
                }, function () {

                });
            };

            $scope.selectedSeats = [];
            $focused_sector_id = 0;

            $(document).ready(function () {
                var $cart = $('#selected-seats'),
                    $counter = $('#counter'),
                    $total = $('#total');
            });


            $('div.sector').click(function(){
                last_sector_id = $focused_sector_id;
                $focused_sector_id = $(this).attr("data-sector-id");
                $('.sNumb').hide();
                $('.sector').removeClass('zindex');
                $('.sector').not(this).addClass('zindex');
                $('.sector-metrics, .seatCharts-container').hide();
                $(this).find('.sector-metrics, .seatCharts-container').show();

                if(last_sector_id != $focused_sector_id){
                    number = $(this).prev().html();
                    $(this).html("<div class='sector-metrics'>Sektor :"+ number+"  Satılıb:  <span id='sector-sold'></span></span> Boş:   <span id='sector-free'></span></div><div class=\"seat-map-" + $focused_sector_id + "\"></div>");
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
                                        $.get('/selling_seat/' + $event_id + '/' + $clickedSeat.settings.id)
                                            .done(function (response) {
                                                selectedSeat = response;
                                                $scope.selectedSeats.push(selectedSeat);
                                                $scope.calculateTotal();
                                                $scope.$apply();
                                            });
                                        return 'selected'
                                    } else if ($clickedSeat.status() == 'selected') {
                                        $scope.selectedSeats.forEach(function(e){
                                            if(e.seat_id == $clickedSeat.settings.id){
                                                $scope.selectedSeats.splice($scope.selectedSeats.indexOf(e), 1)
                                            }
                                            $scope.calculateTotal();
                                            $scope.$apply();
                                        });
                                        return 'available';
                                    } else {
                                        return this.style();
                                    }
                                },
                            focus  : function() {
                                return 'focused'
                            }
                        });
                        $sc.find('o').status('disabled');
                    });
                }
            });
        }])
        .controller('CheckoutController', ['$scope', '$uibModalInstance', 'seats', 'event', '$http', 'locale',
            function ($scope, $uibModalInstance, seats, event, $http, locale) {
                $scope.selectedSeats = seats;
                $scope.event = event;

                $scope.user = { email: "", phone: "" };

                $scope.ok = function () {

                    $http({
                        method: "POST",
                        url: "/" + locale + "/buy-tickets/checkout/" + $scope.event,
                        data: { selected_seats: $scope.selectedSeats }
                    }).then(function (response) {
                        window.location.href = response.data.url;
                    });

                    $uibModalInstance.close();
                };

                $scope.cancel = function () {
                    $uibModalInstance.dismiss('cancel');
                };


            }

        ]);
        angular.bootstrap(document, ['mainApp']);

});

$(window).load(function() {

    var $selectedSeats = [];

    $focused_sector_id = 0;
    $(document).ready(function () {
        var $cart = $('#selected-seats'),
            $counter = $('#counter'),
            $total = $('#total');

    });



    $(document).ready(function () {

        $('.arena, .section').click(function(){
            $('div.sector').html('');
            $('.sector').removeClass('zindex');
            $('.sNumb').fadeIn('slow');
            $focused_sector_id = 0;
            //$sc.find('selected').status('available');
        });




        // $('div.sector').click(function(){
        //     last_sector_id = $focused_sector_id;
        //     $focused_sector_id = $(this).attr("data-sector-id");
        //     $('.sectorNumb, .leftopconefloor2, .leftopconefloor4, .sectorNumbfloor4, .section4floor2, .section4floor2, .leftopconefloor2, .leftbottomconefloor2, .leftbottomconefloor4, .section4floor2, .section4floor4, .sectorNumbfloor2cone3, .sectorNumbfloor4cone3, .sectorNumbfloor2cone5, .sectorNumbfloor4cone5 ').hide();
        //     if(last_sector_id != $focused_sector_id){
        //         $('div.sector').html("");
        //         number = $(this).prev().html();
        //         $(this).html("<div class='sector-metrics'>Sektor :"+ number+"  Satılıb:  <span id='sector-sold'></span>  Bron:  <span id='sector-bron'></span> Boş:   <span id='sector-free'></span></div><div class=\"seat-map-" + $focused_sector_id + "\"></div>");
        //         jQuery.get('/seat_map/' + $focused_sector_id + "/" + $event_id).done(function(data){
        //             $sc = $('.seat-map-' + $focused_sector_id).seatCharts({
        //                 map: data.seat_map,
        //                 seats: {
        //                     o: { classes: 'gray' },
        //                     g: { classes: 'dark-green' }
        //                 },
        //                 naming: {
        //                     left: true,
        //                     top: false,
        //                     rows: data.rows
        //                 },
        //                 click:
        //                     function () {
        //                         $clickedSeat = this;
        //                         if ($clickedSeat.status() == 'available') {
        //
        //                             $.get('/selling_seat/' + $event_id + '/' + $clickedSeat.settings.id)
        //                                 .done(function (response) {
        //                                     selectedSeat = response;
        //                                     $selectedSeats.push(selectedSeat);
        //                                     updateSelectedList();
        //                                 });
        //                             return 'selected'
        //                         } else if ($clickedSeat.status() == 'selected') {
        //                             $selectedSeats.forEach(function(e){
        //                                 if(e.seat_id == $clickedSeat.settings.id){
        //                                     $selectedSeats.splice($selectedSeats.indexOf(e), 1)
        //                                 }
        //                                 console.log(e.seat_id + " <> " + $clickedSeat.settings.id);
        //                             });
        //                             updateSelectedList();
        //                             return 'available';
        //                         } else {
        //                             return this.style();
        //                         }
        //                     },
        //                 focus  : function() {
        //                     return 'focused'
        //                 }
        //             });
        //             $sc.find('o').status('disabled');
        //         });
        //     }
        // });

        $('a.checkout').click(function(event) {
            $(this).modal({
                fadeDuration: 250
            });
            var text2 = selectedHesabla($selectedSeats);
            $("#checkout-modal").text(" : " + text2 + " hello");
            return false;
        });

        function selectedHesabla(array) {
            var testString = "";
            array.forEach(function (ele) {
                testString = testString + ele.seat_id + ", ";
            });
            return testString;
        }

        function updateSelectedList() {
            $cart.empty();
            console.log('cart is emptied now');
            $selectedSeats.forEach(function (selectedSeat) {
                $('<li class="selectedPlaces">' + selectedSeat.seat.real_row + selectedSeat.seat.real_column + ', '+ selectedSeat.price +' AZN </b> <a class="cancel-cart-item">[ləğv et]</a>,</li>')
                    .attr('data-seat-id', selectedSeat.seat.id)
                    .attr('data-event-id', selectedSeat.event_id)
                    .attr('data-sector-id', selectedSeat.seat.sector_id)
                    .attr('title', 'Sektor:  ' +selectedSeat.seat.sector_id)
                    .appendTo($cart);
            });
        }
    });






    // carousel index page
    $('.flexslider').flexslider({
        animation: "slide",
        slideshow: true,
        controlNav: false,
        prevText: "",
        nextText: "",
        start: function(){
            $('#home-slider .descr').removeClass('slideLeft');
            $('#home-slider .flex-active-slide .descr').addClass('slideLeft');
        },
        after: function(){
            $('#home-slider .descr').removeClass('slideLeft');
            $('#home-slider .flex-active-slide .descr').addClass('slideLeft');
        }
    });

    // carousel for page
    $('.flexslider_page').flexslider({
        animation: "slide",
        slideshow: true,
        controlNav: false,
        prevText: "",
        nextText: ""
    });

    // carousel article index page
    $('.slider_articles').flexslider({
        animation: "slide",
        slideshow: false,
        itemWidth: 313,
        itemMargin: 0,
        move: 1,
        minItems: 1,
        controlNav: false,
        prevText: "",
        nextText: ""
    });
    $('.slider_articles_mob').flexslider({
        animation: "slide",
        slideshow: false,
        itemWidth: 200,
        itemMargin: 0,
        move: 1,
        minItems: 1,
        controlNav: false,
        prevText: "",
        nextText: ""
    });

    // carousel gallery opened page
    $('#carousel_gallery').flexslider({
        animation: "slide",
        controlNav: false,
        animationLoop: false,
        slideshow: false,
        itemWidth: 162,
        itemMargin: 6,
        asNavFor: '#slider_gallery',
        prevText: "",
        nextText: ""
    });

    $('#slider_gallery').flexslider({
        animation: "slide",
        controlNav: false,
        smoothHeight: true,
        animationLoop: false,
        slideshow: false,
        sync: "#carousel_gallery",
        prevText: "",
        nextText: ""
    });

    // carousel event opened page
    $('#slider_event').flexslider({
        animation: "slide",
        controlNav: false,
        animationLoop: false,
        slideshow: true,
        prevText: "",
        nextText: ""
    });

    // carousel news page
    $('.news_item_pic').flexslider({
        animation: "slide", //String: Тип анимации, "fade" или "slide"
        slideshow: true,
        controlNav: false, //Boolean: Создание навигации для постраничного управления каждым слайдом.
        prevText: "", //String: Тест для кнопки "previous" пункта directionNav
        nextText: "",  //String: Тест для кнопки "next" пункта directionNav
    });

    // masonry index page
    $('#container').masonry({
        columnWidth: 1,
        itemSelector: '.item'
    });

    //load map for contacts
    loadMapScript();

});

//hide show menu dropdown
function HideShowMenu(){
    $('#nav_dropdown').slideToggle();
}

function mapInit() {
    var mapOptions = {
        zoom: 15,
        center: new google.maps.LatLng(47.028482,28.834198),
        mapTypeId: google.maps.MapTypeId.ROADMAP,
        disableDefaultUI: true,
        navigationControl: false,
        mapTypeControl: false,
        panControl: false
    };
    var map = new google.maps.Map(document.getElementById("map_contact"), mapOptions);
}

function loadMapScript() {
    var script = document.createElement("script");
    script.type = "text/javascript";
    script.src = "http://maps.googleapis.com/maps/api/js?v=3&sensor=false&callback=mapInit";
    document.body.appendChild(script);
}