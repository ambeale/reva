// Event listeners for button clicks on homepage

 $('#rest-srch-btn').on('click', function() {
    $('#rest-srch-btn').toggleClass('active');
    if ($('#DishSearch').hasClass('show')){
      $('#DishSearch').removeClass('show');
      $('#dish-srch-btn').removeClass('active');
    }
  });
  $('#dish-srch-btn').on('click', function() {
    $('#dish-srch-btn').toggleClass('active');
    if ($('#RestSearch').hasClass('show')){
      $('#RestSearch').removeClass('show');
      $('#rest-srch-btn').removeClass('active');
    }
    });