"""Food-focused Restaurant Reviews."""

from jinja2 import StrictUndefined

from flask import (Flask, render_template, redirect, request, flash,
                   session, jsonify)
from flask_debugtoolbar import DebugToolbarExtension

from datetime import datetime

from sqlalchemy import func

from model import (User, Restaurant, Review, Dish, ReviewDish, RestaurantDish,
                    Favorite, connect_to_db, db)
import os, requests, json


app = Flask(__name__)

# Required to use Flask sessions and the debug toolbar
app.secret_key = "betterthanyelp"

# Force jinja to fail loudly
app.jinja_env.undefined = StrictUndefined


### HOMEPAGE ROUTE ###
@app.route('/')
def index():
    """Homepage."""

    return render_template("homepage-bootstrap.html")


### LOG IN / OUT ROUTES ###
@app.route('/login-form')
def display_login_page():
    """Display login page"""

    user = session.get("user_id")

    if user:
        return redirect('/')
    else:
        return render_template("login-bootstrap.html")


@app.route('/login', methods=["POST"]) 
def user_login():
    """Log user into application"""

    user_email = request.form.get("email")
    password = request.form.get("password")

    user_obj = User.query.filter_by(email=user_email).first()

    # If user not in db, flash "user not found"
    if user_obj is None:
        flash("No user found with that email")
        return redirect('/login-form')

    # If username and password match db, save user_id and name to session
    elif user_obj.password == password:
        session['user_id'] = user_obj.user_id
        session['fname'] = user_obj.fname
        flash("Successfully logged in")
        return redirect("/")

    # If user found, but password wrong, flash "wrong password"
    else:
        flash("Password incorrect")
        return redirect("/login-form")


@app.route('/logout')
def user_logout():
    """Log user out"""

    if session.get("user_id"):
        # Delete user_id and name from session
        session.pop('user_id', None)
        session.pop('fname', None)

        flash("You're logged out. See you next time.")
    return redirect('/')


@app.route('/new-account-form')
def display_account_creation_page():
    """Display account creation page"""

    return render_template("create_account.html")


@app.route('/create-account', methods=["POST"])
def create_new_user():
    """Add new user to database."""
    
    fname = request.form.get("fname")
    lname = request.form.get("lname")
    new_email = request.form.get("email")
    password = request.form.get("password")
    zipcode = request.form.get("zipcode")

    email_match = User.query.filter(User.email == new_email).first()

    if email_match:
        flash('Account for this email already created')
    else:
        new_user = User(email=new_email, fname=fname, lname=lname,
                        password=password, zipcode=zipcode)
        db.session.add(new_user)
        db.session.commit()

        flash("You've been added!")

    return redirect('/login-form')


@app.route('/profile')
def display_user_profile_page():
    """Render user's profile page"""

    user = session.get("user_id")

    if not user:
        flash("Please log in to view this page")
        return redirect('/login-form')

    user_info = User.query.filter_by(user_id=user).first()

    return render_template("user_profile.html", user=user_info)


### FAVORITING ROUTES ###

@app.route('/update-favorite', methods=["POST"])
def update_user_favorites():
    """When user clicks heart icon, add or remove
    restaurant from user's favorites"""

    user_id = session.get("user_id")
    restaurant_id = request.form.get("restaurant_id")

    favorite = Favorite.query.filter(Favorite.user_id==user_id,
                                  Favorite.restaurant_id==restaurant_id
                                  ).first()
    
    # If already a favorite, unfavorite restaurant
    if favorite:
        db.session.delete(favorite)
        message = "Favorite removed"
    
    # If not a favorite, add to favorites table
    else:
        new_favorite = Favorite(user_id=user_id, restaurant_id=restaurant_id)
        db.session.add(new_favorite)
        message = "Favorite added"

    db.session.commit()
    return jsonify(message)


@app.route('/is-favorite')
def is_restaurant_user_favorite():
    """Return boolean of whether a given restaurant is in a user's favorites"""

    user_id = request.args.get("user_id")
    restaurant_id = request.args.get("restaurant")

    favorite = Favorite.query.filter(Favorite.user_id==user_id,
                                  Favorite.restaurant_id==restaurant_id
                                  ).first()

    # If already a favorite, return true
    if favorite:
        return jsonify(True)
    else:
        return jsonify(False)


### API ROUTE ###

@app.route('/geocode-helper')
def return_key_for_geocoding():
    """Return API key to allow front-end to geocode location
    with Google API request"""

    return jsonify(os.environ['GOOGLE_API_KEY'])


### RESTAURANT ROUTES ###

@app.route('/restaurant-search')
def display_restaurant_results():
    """Call Google API with given search terms and return restaurants"""

    # Get submitted search terms
    term = request.args.get('search-restaurant')
    location = request.args.get('restaurant-location')

    # Call helper function to make Google Places API call
    response = restaurant_api_call(term, location)
    results = add_rest_review_count_json(response)
    full_results = add_rest_ratings_json(results)
    print(results)

    # Render template with search results
    return render_template("restaurant_search_results.html",
                             results=full_results)


@app.route('/restaurant/<place_id>')
def display_restaurant(place_id):
    """display resturant details and reviews"""

    restaurant = Restaurant.query.filter_by(restaurant_id=place_id).first()

    # If restaurant in database, query and pass to template
    if restaurant:
        restaurant.count_reviews = len(restaurant.reviews)
        restaurant.reva_rating = calculate_overall_rating(restaurant.reviews)
        return render_template("restaurant_details.html",
                                restaurant=restaurant,
                                api_key=os.environ['GOOGLE_API_KEY'])

    # If restaurant not in database, trigger Place API request
    else:
        fields = 'name,formatted_phone_number,formatted_address,geometry,website'
        payload = {'place_id': place_id,
                    'fields': fields,
                    'key': os.environ['GOOGLE_API_KEY']}
        url = 'https://maps.googleapis.com/maps/api/place/details/json?'

        r = requests.get(url, params=payload)

        r = r.json()
        result = r['result']

        # Details to create Restaurant object
        name = result['name']
        phone_number = result.get('formatted_phone_number')
        address = result.get('formatted_address')
        website = result.get('website')
        lat = result['geometry']['location']['lat']
        lon = result['geometry']['location']['lng']


        new_restaurant = Restaurant(restaurant_id=place_id,
                                    name=name,
                                    phone_number=phone_number,
                                    address=address,
                                    website=website,
                                    lat=lat,
                                    lon=lon)

        db.session.add(new_restaurant)
        db.session.commit()

        new_restaurant.count_reviews = "N/A"
        new_restaurant.reva_rating = "N/A"

        return render_template("restaurant_details.html",
                                restaurant=new_restaurant,
                                api_key=os.environ['GOOGLE_API_KEY'])


@app.route("/ratings/<restaurant_id>.json")
def render_bar_chart(restaurant_id):
    """Given restaurant id, return json response of average ratings"""

    restaurant = Restaurant.query.filter_by(restaurant_id=restaurant_id).first()
    if restaurant.reviews:
        ratings = calculate_individual_ratings(restaurant.reviews)
        return jsonify(ratings)

    else:
        return jsonify("no reviews")


@app.route("/review-form")
def render_review_creation_page():
    """Take user to page to create review"""

    user = session.get("user_id")

    if not user:
        flash("Please log in to add a review")
        return redirect('/login-form')

    name = request.args.get("restaurant-name")
    restaurant = request.args.get("restaurant-id")

    return render_template("add_review.html",
                            name=name,
                            restaurant_id=restaurant)


@app.route("/restaurant-dish-search")
def render_restaurant_dish_search():
    """Search for dishes matching restaurant and dish"""

    dish = request.args.get("dish-search")
    search_input = "%" + dish + "%"
    restaurant = request.args.get("restaurant-id")

    
    query = db.session.query(Dish).join(RestaurantDish)
    matching_dishes = query.filter(RestaurantDish.restaurant_id==restaurant,
                                    Dish.name.ilike(search_input)).all()

    print(matching_dishes)

    return render_template("restaurant_dish_search_results.html",
                            dishes=matching_dishes,
                            search_dish=dish, restaurant_id=restaurant)


@app.route("/add-review", methods=["POST"])
def add_review():
    """Add user's review to database"""

    # Get review and dish inputs
    user_id = request.form.get("user-id")
    restaurant_id = request.form.get("restaurant-id")
    food_score = request.form.get("food-score")
    food_comment = request.form.get("food-comment")
    service_score = request.form.get("service-score")
    service_comment = request.form.get("service-comment")
    price_score = request.form.get("price-score")
    price_comment = request.form.get("price-comment")
    dish_names = json.loads(request.form.get("dishes"))

    # Check if user has already reviewed restaurant
    user_review_check = Review.query.filter_by(user_id=user_id,
                                               restaurant_id=restaurant_id)
    
    # If user has reviewed, send back to restaurant page
    if user_review_check.first():
        flash("You've already reviewed this restaurant")
        return jsonify(restaurant_id)
    
    # Else create new review
    else:
        new_review = Review(user_id=user_id,
                            restaurant_id=restaurant_id,
                            food_score=food_score,
                            food_comment=food_comment,
                            service_score=service_score,
                            service_comment=service_comment,
                            price_score=price_score,
                            price_comment=price_comment)
        db.session.add(new_review)
        db.session.commit()
        flash("Review successfully added")

    # If no dishes, finished => redirect to restaurant page
    if not dish_names:
        return jsonify(restaurant_id)

    add_dishes_to_db(dish_names, new_review, restaurant_id)

    # Return to restaurant home page
    return jsonify(restaurant_id)


######### USER SEARCH ROUTES ###########

@app.route("/user-search")
def search_users():
    """Search for users given name and/or email inputs"""

    search_term = "%" + request.args.get("search-name") + "%"

    returned_users = User.query.filter(func.concat(User.fname, ' ', User.lname
                                                    ).ilike(search_term)).all()
    user_results = calculate_user_review_count(returned_users)

    return render_template("user_search_results.html", results=user_results)


@app.route("/user/<user_id>")
def display_user_details(user_id):
    """Display details of a user profile"""

    user = User.query.filter_by(user_id=user_id).first()

    return render_template("user_details.html", user=user)


######### DISH ROUTES ##########

@app.route("/dish-search")
def search_dishes():
    """Search for reviewed dishes near given location"""

    search_dish = request.args.get("search-dish")
    location = request.args.get("dish-location")

    search_term = "%" + search_dish + "%"
    matching_dishes = Dish.query.filter(Dish.name.ilike(search_term)).all()

    return render_template("matching_dishes.html", dishes=matching_dishes,
                            location=location, search_dish=search_dish)


@app.route("/dish-details/<dish_id>/<location>")
def deplay_dish_details(dish_id, location):
    """Display details of chosen dish"""

    query = Dish.query.filter_by(dish_id=dish_id).options(
                                            db.joinedload('restaurant_dishes')
                                            ).first()

    rest_dishes = query.restaurant_dishes
    restaurants = set()

    for rest_dish in rest_dishes:
        restaurant = rest_dish.restaurant
        food_avg, service_avg, price_avg = calculate_individual_ratings(
                                                            restaurant.reviews)
        restaurant.food_avg = food_avg
        restaurants.add(restaurant)


    return render_template("dish_details.html", dish=query, results=restaurants)


@app.route("/dish-reviews/<dish_id>/<restaurant_id>")
def display_dish_reviews_from_restaurant(dish_id, restaurant_id):
    """Display reviews associated with a given dish and restaurant"""

    query = db.session.query(Review).join(ReviewDish)
    reviews = query.filter(Review.restaurant_id==restaurant_id,
                            ReviewDish.dish_id==dish_id).all()

    dish = Dish.query.filter_by(dish_id=dish_id).first()
    restaurant = Restaurant.query.filter_by(restaurant_id=restaurant_id).first()


    return render_template("rest_dish_reviews.html",
                            reviews=reviews,
                            dish=dish,
                            restaurant=restaurant)


@app.route("/get-matching-dishes.json", methods=["POST"])
def return_matching_dishes():
    """Query dishes table for matching entries and return json list"""

    search_term = "%" + request.form.get("query") + "%"
    print(search_term)

    matching_dishes = Dish.query.filter(Dish.name.ilike(search_term)).all()
    dishes_list = []

    for dish in matching_dishes:
        dishes_list.append({"id": dish.dish_id, "name": dish.name})

    return jsonify(dishes_list)


####### HELPER FUNCTIONS #######

def add_dishes_to_db(dish_names, new_review, restaurant_id):
    """Add dishes to dishes table and middle tables"""

    # If dishes associated => handle each dish tag
    for dish in dish_names:
        # If dish_id comes back from JS as a name (not id), it is a new dish
        try:
            int(dish['id'])
        except Exception as e:
            dish_obj = None
        else:
            dish_obj = Dish.query.filter(Dish.dish_id == dish['id']).first()
        finally:
            # if dish not in dishes table, add it
            if not dish_obj:
                dish_name = dish['name'].capitalize()
                dish_obj = Dish(name=dish_name)
                db.session.add(dish_obj)
                db.session.commit()

            # Deal with middle table - add new review dish
            new_review_dish = ReviewDish(dish_id=dish_obj.dish_id,
                                         review_id=new_review.review_id)
            db.session.add(new_review_dish)

            # Deal with association table - 
            # Check if restaurant and dish are already linked
            rest_dish_check = RestaurantDish.query.filter_by(
                                                    dish_id=dish_obj.dish_id,
                                                    restaurant_id=restaurant_id
                                                    ).first()
            
            # if RestaurantDish not in table, add it
            if not rest_dish_check:
                new_rest_dish = RestaurantDish(dish_id=dish_obj.dish_id,
                                               restaurant_id=restaurant_id)
                db.session.add(new_rest_dish)

            db.session.commit()


def restaurant_api_call(term, location):
    """Call Google Places Text Search API using given search terms
    and return results"""

    search_term = term.replace(" ", "+")
    lat_lng = get_geocoded_lat_lon(location)

    payload = {'query': search_term,
                'location': "{},{}".format(lat_lng['lat'], lat_lng['lng']),
                'type': 'food', #bakery, bar, cafe, restaurant, supermarket, meal_takeaway, meal_delivery
                'key': os.environ['GOOGLE_API_KEY']}
    url = 'https://maps.googleapis.com/maps/api/place/textsearch/json?'

    r = requests.get(url, params=payload).json()
    results = r['results']

    return results


def get_geocoded_lat_lon(location):
    """Given string of search location,
    return lat and lon using Google Geocoding API"""

    # Format input for search
    search_location = location.replace(",","").replace(" ", "+")

    payload = {'address': search_location,
                'key': os.environ['GOOGLE_API_KEY']}
    url = 'https://maps.googleapis.com/maps/api/geocode/json?'

    # Make request to Geocoding API and return lat lng of result
    r = requests.get(url, params=payload).json()
    lat_lng = r['results'][0]['geometry']['location']

    return lat_lng


def add_rest_review_count_json(results):
    """Given Google API json response (list of dicts), calculate and add
    number of reviews for each restaurant"""

    for index, restaurant in enumerate(results):
        place_id = restaurant['place_id']
        review_count = Review.query.filter_by(restaurant_id=place_id).count()
        results[index]['count_reviews'] = review_count

    return results


def add_rest_ratings_json(results):
    """Given Google API json response (list of dicts), calculate and add rating
    for each restaurant"""

    for index, result in enumerate(results):
        # If restaurant object has no reviews, set value as N/A
        if result.get('count_reviews') == 0:
            results[index]['reva_rating'] = "N/A"
        
        # Else do query to get ratings
        else:
            place_id = result['place_id']
            restaurant = Restaurant.query.filter_by(restaurant_id=place_id
                                                       ).first()
            review_scores = restaurant.reviews

            # Only calculate if query returns reviews
            if review_scores:
                restaurant_rating = calculate_overall_rating(review_scores)
                results[index]['reva_rating'] = restaurant_rating

    return results


def calculate_overall_rating(reviews):
    """Given list of Review objects, use algorithm to return overall rating

    >>> test = Restaurant(restaurant_id="test")
    >>> test.ratings = [Review(food_score=4, service_score=5, price_score=5),
    ...                 Review(food_score=3, service_score=4, price_score=5),
    ...                 Review(food_score=2, service_score=3, price_score=5)]
    >>> calculate_overall_rating(test.ratings)
    3.65

    """

    if len(reviews) == 0:
        return 0.0;


    # Get score averages
    food_avg, service_avg, price_avg = calculate_individual_ratings(reviews)    

    # Calculate overall average using proprietary algorithm
    overall_avg = round((food_avg * 0.5) + (service_avg * 0.35)
                                         + (price_avg * 0.15), 2)

    return overall_avg


def calculate_individual_ratings(reviews):
    """Given list of Review objects, calculate and return tuple of score 
    averages for each category"""

    if len(reviews) == 0:
        return 0.0;

    food_sum = 0.0
    service_sum = 0.0
    price_sum = 0.0
    num_reviews = len(reviews)

    for r in reviews: # (food, service, price)
        food_sum += r.food_score
        service_sum += r.service_score
        price_sum += r.price_score

    food_avg = food_sum / num_reviews
    service_avg = service_sum / num_reviews
    price_avg = price_sum / num_reviews

    return (food_avg, service_avg, price_avg)


def calculate_user_review_count(user_list):
    """Given list of Users, calculate number of reviews and add to 
    each User object"""

    # for each user object, add attribute for number of reviews
    for user in user_list:
        review_count = len(user.reviews)
        user.count_reviews = review_count

    return user_list


def example_data():
    """Create some sample user data."""

    User.query.delete()

    jane = User(user_id=1, email='jane@gmail.com', fname='Jane', lname='Doe',
                password='hellojane')
    jack = User(user_id=2, email='jack@gmail.com', fname='Jack', lname='Dee',
                password='hellojack')

    db.session.add_all([jane, jack])
    db.session.commit()


if __name__ == "__main__":
    # We have to set debug=True here, since it has to be True at the
    # point that we invoke the DebugToolbarExtension
    app.debug = True
    # make sure templates, etc. are not cached in debug mode
    app.jinja_env.auto_reload = app.debug

    connect_to_db(app)

    # Use the DebugToolbar
    DebugToolbarExtension(app)

    app.config['DEBUG_TB_INTERCEPT_REDIRECTS'] = False

    app.run(port=5000, host='0.0.0.0')
