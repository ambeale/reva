// Intercept new-review form submission and update db

let dishes = $('#ms-data-ajax').magicSuggest({
                      data: '/get-matching-dishes.json',
                      placeholder: 'Add dishes'
                    });

let reviewForm = document.querySelector('#review-form');

reviewForm.addEventListener('submit', function (evt) {
    evt.preventDefault();

    // Get submitted form data, then add MagicSuggest dish tags
    let form_data = new FormData(reviewForm);
    form_data.append("dishes", JSON.stringify(dishes.getSelection()));

    // Make ajax call to backend to save review
    $.ajax({
            type: 'POST',
            url: '/add-review',
            data: form_data,
            contentType: false,
            cache: false,
            processData: false,
            success: successFunction,
     });

    // Deprecated post request
    // var formInputs = {
    //     "user-id": $("#user-id").val(),
    //     "restaurant-id": $("#restaurant").val(),
    //     "food-score": $("#food-score").val(),
    //     "file": "file",
    //     "food-comment": $("#food-comment").val(),
    //     "service-score": $("#service-score").val(),
    //     "service-comment": $("#service-comment").val(),
    //     "price-score": $("#price-score").val(),
    //     "price-comment": $("#price-comment").val(),
    //     "dishes": JSON.stringify(dishes.getSelection())
    // };

    // $.post("/add-review", 
    //        formInputs,
    //        successFunction);

});

function successFunction(results) {
    console.log(results);
    window.location.replace(`/restaurant/${results}`);
}