var version = '0.05';
var debugmode = false;
var addinelement = '';
var apiwebsource = '';
var zoomlevel = 14;
var map;
var markers = [];
var alternate_url = '';

function RecieveInitMapViewData(AddInData) {
    if (AddInData != '') {
        json = $.xml2json(AddInData);
        apiwebsource = json.MapView['ApiWebsource'];
    }

    $.getScript(apiwebsource, function () {
        RecieveRefreshMapViewData(AddInData);
    });
}

function RecieveRefreshMapViewData(AddInData) {   
    if (debugmode) {
        $('#serviceInfoContainer').text(AddInData);
    }
    $('#url').empty();
    ClearAllMarkers();

    if (AddInData != '') {
        json = $.xml2json(AddInData);
        if (json.MapView['ZoomLevel'] != undefined) {
            zoomlevel = parseInt(json.MapView['ZoomLevel']);
        }
        if (json.MapView.Locations.Location != undefined) { 
            if (json.MapView.Locations.Location.length != undefined) {
                $.each(json.MapView.Locations.Location, function (i, val) {
                    AddMarkerToMap(val);
                    AddAlternateUrl(alternate_url);
                    if (i == 0) {
                        CenterMap(val);
                    }
                });
            } else {
                val = json.MapView.Locations.Location;
                AddMarkerToMap(val);
                AddAlternateUrl(alternate_url);
                CenterMap(val);
            }
        }
    }
}

function InitializeApp() {    
	addinelement = 'mapview_element';
    //$('head').prepend('<meta http-equiv="x-ua-compatible" content="IE=edge">');
    
    //var meta = window.document.createElement('meta');
    //meta.httpEquiv = "X-UA-Compatible";
    //meta.content = "IE=edge";
    //window.document.getElementsByTagName('head')[0].appendChild(meta);

    $('#controlAddIn').css("overflow", "auto").append(
        '<div id="' + addinelement + '" class="' + addinelement + '" style="padding:0;margin:0;width:100%;">' +
        '<div id="map"></div>' +
        '<div id="url" style="position:absolute;z-index:9998; bottom:0;"></div>' +
        '</div>'
    );

    var initialCss = '#map {height: 200px;width: 100 %;} #url{font-family: arial; font-size: 0.7em; left:50%; margin-left: -40px; }';
    $('<style>').text(initialCss).appendTo('head');

    if (debugmode) {
        $('#controlAddIn').append('<textarea id="serviceInfoContainer" style="position:absolute;z-index:9999; bottom:0; right:20;"></textarea>');
    }
}


function CenterMap(location) {    
    var uluru = { lat: Number(location.Latitude.replace(/,/g, '.')), lng: Number(location.Longitude.replace(/,/g, '.'))};
    map = new google.maps.Map(document.getElementById('map'), {
        zoom: zoomlevel,
        
        center: uluru,
        mapTypeId: google.maps.MapTypeId.ROADMAP,
        disableDefaultUI: true,
        zoomControl: true,
        fullscreenControl: true
    });

    var gotoMapButton = document.createElement("div");
    gotoMapButton.setAttribute("style", "margin: 5px; border: 1px solid; padding: 1px 12px; font: bold 11px Roboto, Arial, sans-serif; color: #000000; background-color: #FFFFFF; cursor: pointer;");
    gotoMapButton.innerHTML = "Open in google maps";
    map.controls[google.maps.ControlPosition.TOP_LEFT].push(gotoMapButton);
    google.maps.event.addDomListener(gotoMapButton, "click", function () {
        var url = 'https://www.google.com/maps?q=' + uluru.lat + ',' + uluru.lng + '&ll=' + uluru.lat + ', ' + uluru.lng + '&z=' + zoomlevel+'&v=3';
        // you can also hard code the URL
        window.open(url);
    });
    
}

function AddMarkerToMap(location) {
    var uluru = { lat: Number(location.Latitude.replace(/,/g, '.')), lng: Number(location.Longitude.replace(/,/g, '.')) };
    if (uluru.lat != '') {
        alternate_url = 'https://www.google.com/maps?q=' + uluru.lat + ',' + uluru.lng + '&ll=' + uluru.lat + ', ' + uluru.lng + '&z=' + zoomlevel + '&v=3';
    }
    var i;
    var infowindow = new google.maps.InfoWindow();
    var marker = new google.maps.Marker({
        position: uluru,
        map: map
    });

    markers.push(marker);

    google.maps.event.addListener(marker, 'click', (function (marker, i) {
        return function () {
            infowindow.setContent(location.Description);
            infowindow.open(map, marker);
        }
    })(marker, i));
}

function ClearAllMarkers() {
    for (var i = 0; i < markers.length; i++) {
        markers[i].setMap(null);
    }
    markers = [];
}

function AddAlternateUrl(url) {
    if (url != '') {
        //$('#url').empty().append('<a target="_blank" href="' + url + '">Open in browser</a>');
    }
}