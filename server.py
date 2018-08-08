"""Food-focused Restaurant Reviews."""

from jinja2 import StrictUndefined

from flask import (Flask, render_template, redirect, request, flash,
                   session)
from flask_debugtoolbar import DebugToolbarExtension

from datetime import datetime

from sqlalchemy import func

from model import (User, Restaurant, Review, Dish, ReviewDish, RestaurantDish,
                    connect_to_db, db)
import os, requests


app = Flask(__name__)

# Required to use Flask sessions and the debug toolbar
app.secret_key = "betterthanyelp"

# Force jinja to fail loudly
app.jinja_env.undefined = StrictUndefined


@app.route('/')
def index():
    """Homepage."""

    return render_template("homepage.html")


@app.route('/login-form')
def display_login_page():
    """Display login page"""

    return render_template("login.html")


@app.route('/login')
def user_login():
    """Log user into application"""

    user_email = request.args.get("email")
    password = request.args.get("password")

    user_obj = User.query.filter_by(email=user_email).first()

    if user_obj is None:
        #flash you don't exist 
        flash("No user found with that email")
        return redirect('/login')

    elif user_obj.password == password:
        session['user_id'] = user_obj.user_id
        flash("Successfully logged in")
        return redirect("/")

    else:
        flash("Password incorrect")
        return redirect("/login")


@app.route('/logout')
def user_logout():
    """Log user out"""

    del session['user_id']

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
        flash('You already exist.')
    else:
        new_user = User(email=new_email,
                        fname=fname,
                        lname=lname,
                        password=password,
                        zipcode=zipcode)
        db.session.add(new_user)
        db.session.commit()

        flash("You've been added!")

    return redirect('/login-form')

@app.route('/restaurant-search')
def display_restaurant_results():
    """Call Google API with given search terms and return restaurants"""

    # Get submitted search terms
    term = request.args.get('search-term')
    location = request.args.get('location')

    # Call helper function to make Google Places API call
    response = restaurant_api_call(term, location)
    results = response['results']
    results_with_count = calculate_rest_review_count(results)

    # Render template with search results
    return render_template("restaurant_search_results.html",
                             results=results_with_count)


def restaurant_api_call(term, location):
    """Call Google Places Text Search API using given search terms"""

    search_term = term.replace(" ", "+")
    search_location = location.replace(",","").replace(" ", "+")
    # query = search_term + "+in+" + search_location

    payload = {'query': search_term + "+in+" + search_location,
                'type': 'restaurant',
                'key': os.environ['PLACE_API_KEY']}
    url = 'https://maps.googleapis.com/maps/api/place/textsearch/json?'

    r = requests.get(url, params=payload)

    return r.json()


def calculate_rest_review_count(results):
    """Given json response, calculate number of reviews
    for each return restaurant"""

    for index, result in enumerate(results):
        place_id = result['place_id']
        review_count = Review.query.filter_by(restaurant_id=place_id).count()
        results[index]['count_reviews'] = review_count

    return results

@app.route('/<place_id>')
def display_restaurant(place_id):
    """ADD DOCSTRING"""

    query = Restaurant.query.filter_by(restaurant_id=place_id).first()

    # If restaurant in database, query and pass to template
    if query:
        return render_template("restaurant_details.html", restaurant=query)

    # If restaurant not in database, trigger Place API request
    else:
        fields = 'name,formatted_phone_number,formatted_address,geometry,website'
        payload = {'place_id': place_id,
                    'fields': fields,
                    'key': os.environ['PLACE_API_KEY']}
        url = 'https://maps.googleapis.com/maps/api/place/details/json?'

        r = requests.get(url, params=payload)

        r = r.json()
        result = r['result']

        # Details to create Restaurant object
        name = result['name']
        phone_number = result['formatted_phone_number']
        address = result['formatted_address']
        website = result['website']
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

        return render_template("restaurant_details.html",
                                restaurant=new_restaurant)


@app.route("/add-review", methods=["POST"])
def add_review():
    """Add user's review to database"""

    # Get review inputs
    user_id = session.get("user_id")
    restaurant_id = request.form.get("restaurant")
    created_at = datetime.now()
    food_score = request.form.get("food-score")
    food_comment = request.form.get("food-comment")
    service_score = request.form.get("service-score")
    service_comment = request.form.get("service-comment")
    price_score = request.form.get("price-score")
    price_comment = request.form.get("price-comment")
    
    # Get dish inputs
    if request.form.get("dish-name"):
        dish_name = request.form.get("dish-name").capitalize()
    dish_comment = request.form.get("dish-comment")

    # Check if user has already reviewed restaurant
    user_review_check = Review.query.filter_by(user_id=user_id,
                                               restaurant_id=restaurant_id)
    if user_review_check.first():
        flash("You've already review this restaurant")
    else:
        new_review = Review(user_id=user_id,
                            restaurant_id=restaurant_id,
                            created_at=created_at,
                            food_score=food_score,
                            food_comment=food_comment,
                            service_score=service_score,
                            service_comment=service_comment,
                            price_score=price_score,
                            price_comment=price_comment)
        db.session.add(new_review)
        db.session.commit()
        flash("Review successfully added")

    # Check if reviewed dish is in dishes table
    dish_obj = Dish.query.filter(Dish.name == dish_name).first()

    # if dish not in dishes table, add it
    if not dish_obj:
        dish_obj = Dish(name=dish_name)
        db.session.add(dish_obj)
        db.session.commit()

    # Add new review dish
    new_review_dish = ReviewDish(dish_id=dish_obj.dish_id,
                                 review_id=new_review.review_id,
                                 dish_comment=dish_comment)
    db.session.add(new_review_dish)

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

    return redirect('/{}'.format(restaurant_id))


@app.route("/user-search")
def search_users():
    """Search for users given name and/or email inputs"""

    search_term = "%" + request.args.get("search-name") + "%"

    returned_users = User.query.filter(func.concat(User.fname, ' ', User.lname
                                                    ).like(search_term)).all()
    user_results = calculate_user_review_count(returned_users)

    return render_template("user_search_results.html",
                            results=user_results)


def calculate_user_review_count(user_list):
    """Calculate number of reviews for each given user"""

    # for each user object, add attribute for number of reviews
    for user in user_list:
        review_count = len(user.reviews)
        user.count_reviews = review_count

    return user_list


@app.route("/user/<user_id>")
def display_user_details(user_id):
    """Display details of a user profile"""

    user = User.query.filter_by(user_id=user_id).first()

    return render_template("user_details.html", user=user)


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
