"""Food-focused Restaurant Reviews."""

from jinja2 import StrictUndefined

from flask import (Flask, render_template, redirect, request, flash,
                   session)
from flask_debugtoolbar import DebugToolbarExtension

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
    
    results_with_count = calculate_review_count(results)
    print(results_with_count)

    # Render template with search results
    return render_template("search_results.html", results=results_with_count)


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


def calculate_review_count(results):
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
        fields = 'name,formatted_phone_number,formatted_address,geometry'
        payload = {'place_id': place_id,
                    'fields': fields,
                    'key': os.environ['PLACE_API_KEY']}
        url = 'https://maps.googleapis.com/maps/api/place/details/json?'

        r = requests.get(url, params=payload)
        print(r.url)
        r = r.json()
        result = r['result']

        # Details to create Restaurant object
        name = result['name']
        phone_number = result['formatted_phone_number']
        address = result['formatted_address']
        lat = result['geometry']['location']['lat']
        lon = result['geometry']['location']['lng']


        new_restaurant = Restaurant(restaurant_id=place_id,
                                    name=name,
                                    phone_number=phone_number,
                                    address=address,
                                    lat=lat,
                                    lon=lon)

        db.session.add(new_restaurant)
        db.session.commit()

        return render_template("restaurant_details.html",
                                restaurant=new_restaurant)


@app.route("/add-review", methods=["POST"])
def add_review():
    """Add user's review to database"""

    # user_id = request.form.get("fname")
    # restaurant_id = request.form.get("lname")
    # created_at = 
    # food_score = 
    # food_comment = 
    # service_score = 
    # service_comment = 
    # price_score = 
    # price_comment = 


    return redirect("/")


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
