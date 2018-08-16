// Intercept new-review form submission and update db

let dishes = $('#ms-data-ajax').magicSuggest({
                      data: '/get-matching-dishes.json',
                      placeholder: 'Add dishes'
                    });

let reviewForm = document.querySelector('#review-form');

reviewForm.addEventListener('submit', function (evt) {
    evt.preventDefault();

    var formInputs = {
        "user-id": $("#user-id").val(),
        "restaurant-id": $("#restaurant").val(),
        "food-score": $("#food-score").val(),
        "food-comment": $("#food-comment").val(),
        "service-score": $("#service-score").val(),
        "service-comment": $("#service-comment").val(),
        "price-score": $("#price-score").val(),
        "price-comment": $("#price-comment").val(),
        "dishes": JSON.stringify(dishes.getSelection())
    };

    $.post("/add-review", 
           formInputs,
           successFunction);
});

function successFunction(results) {
    console.log(results);
    window.location.replace(`/restaurant/${results}`);
}