// Intercept new-review form submission and update db

let dishes = $('#ms-data-ajax').magicSuggest({
                      data: '/get-matching-dishes.json',
                      placeholder: 'Add dishes'
                    });

let reviewForm = document.querySelector('#review-form');

reviewForm.addEventListener('submit', function (evt) {
    evt.preventDefault();

    setTimeout(function(){
     $('#spinnerModal').modal('show');
    }, 1000);
    

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
});

function successFunction(results) {
    console.log(results);
    window.location.replace(`/restaurant/${results}`);
}