"""Food-focused Restuarant Reviews."""

from jinja2 import StrictUndefined

from flask import (Flask, render_template, redirect, request, flash,
                   session)
from flask_debugtoolbar import DebugToolbarExtension

from model import User, connect_to_db, db

import os, requests

#import json


app = Flask(__name__)

# Required to use Flask sessions and the debug toolbar
app.secret_key = "ABC"

# Force jinja to fail loudly
app.jinja_env.undefined = StrictUndefined


@app.route('/')
def index():
    """Homepage."""
    return render_template("homepage.html")


@app.route('/restaurant-search')
def display_restaurants():
    """Call Google API with given search terms and return restaurants"""

    term = request.args.get('search-term')
    location = request.args.get('location')

    response = restaurant_api_call(term, location)
    print(response['results'])

    return render_template("search_results.html", results=response['results'])


def restaurant_api_call(term, location):
    """ADD DOCSTRING"""

    search_term = term.replace(" ", "+")
    search_location = location.replace(",","").replace(" ", "+")
    # query = search_term + "+in+" + search_location

    payload = {'query': search_term + "+in+" + search_location,
                'key': os.environ['TEXT_SEARCH_KEY']}
    url = 'https://maps.googleapis.com/maps/api/place/textsearch/json?'

    r = requests.get(url, params=payload)
    print(r.url)

    return r.json()



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
