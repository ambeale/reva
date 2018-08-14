// Query html for lat and lon and display map of restaurant location

var map;

function initMap() {

    lat = JSON.parse(document.querySelector('#map').getAttribute('lat'));
    lon = JSON.parse(document.querySelector('#map').getAttribute('lon'));
    var myLatlng = new google.maps.LatLng(lat, lon);

    var mapOptions = {
      zoom: 15,
      center: myLatlng
    }

    var map = new google.maps.Map(document.getElementById("map"), mapOptions);

    var marker = new google.maps.Marker({
        position: myLatlng,
        title:"Hello World!"
    });
    marker.setMap(map);
}