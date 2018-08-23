// On search click, populate search bar with current location as default

function success(data) {
    const crd = data.coords;
    $.get("/geocode-helper", function(key) {
      $.get(`https://maps.googleapis.com/maps/api/geocode/json?latlng=\
        ${crd.latitude},${crd.longitude}&key=${key}`, updateLocation)
    })   
}

function updateLocation(results) {
    const currentLocation = results['results'][0]['formatted_address'];
    $("#restaurant-location").attr("value", currentLocation);
    $("#dish-location").attr("value", currentLocation);
}

$("#rest-srch-btn").one('click', function() {
    navigator.geolocation.getCurrentPosition(success);
})

$("#dish-srch-btn").one('click', function() {
    navigator.geolocation.getCurrentPosition(success);
})
