"""Models and database functions for Hackbright Food Review project."""

from flask_sqlalchemy import SQLAlchemy
from datetime import datetime

# This is the connection to the PostgreSQL database; we're getting this through
# the Flask-SQLAlchemy helper library. On this, we can find the `session`
# object, where we do most of our interactions (like committing, etc.)

db = SQLAlchemy()


##############################################################################
# Model definitions

class User(db.Model):
    """User of review website."""

    __tablename__ = "users"

    default_icon = """https://images.unsplash.com/photo-1491273289208-
                      9340cb42e5d9?crop=entropy&fm=jpg&w=150&h=150&fit=crop"""

    user_id = db.Column(db.Integer, autoincrement=True, primary_key=True)
    email = db.Column(db.String(64), nullable=False)
    fname = db.Column(db.String(64), nullable=False)
    lname = db.Column(db.String(64), nullable=False)
    password = db.Column(db.String(64), nullable=False)
    zipcode = db.Column(db.String(15), nullable=True)
    icon = db.Column(db.String(300), nullable=False, default=default_icon)

    def __repr__(self):
        """Provide helpful representation when printed"""

        return "<User user_id= {} email = {}>".format(self.user_id, self.email)


class Restaurant(db.Model):
    """Restaurant on review website."""

    __tablename__ = "restaurants"

    restaurant_id = db.Column(db.String(200), primary_key=True)
    name = db.Column(db.String(200), nullable=True) # change to False
    phone_number = db.Column(db.String(20), nullable=True)
    address = db.Column(db.String(200), nullable=True)
    website = db.Column(db.String(200), nullable=True)
    lat = db.Column(db.Numeric, nullable=True)
    lon = db.Column(db.Numeric, nullable=True)

    def __repr__(self):
        """Provide helpful representation when printed"""

        return "<Restaurant id= {} name = {}>".format(self.restaurant_id, 
                                                      self.name)


class Favorite(db.Model):
    """Favorite restaurants of users"""

    __tablename__ = "favorites"

    favorite_id = db.Column(db.Integer, autoincrement=True, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.user_id'))
    restaurant_id = db.Column(db.String(200), db.ForeignKey(
                                                'restaurants.restaurant_id'))

    # Relationships
    restaurant = db.relationship("Restaurant", backref=db.backref("favorites"))
    user = db.relationship("User", backref=db.backref("favorites"))

    
    def __repr__(self):
        """Provide helpful representation when printed"""

        return """<Favorite id={} user_id={}
                    restaurant_id={}>""".format(self.favorite_id, 
                                                self.user_id,
                                                self.restaurant_id)


class Review(db.Model):
    """Review on website."""

    __tablename__ = "reviews"

    review_id = db.Column(db.Integer, autoincrement=True, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.user_id'))
    restaurant_id = db.Column(db.String(200), db.ForeignKey(
                                                'restaurants.restaurant_id'))
    created_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)
    food_score = db.Column(db.Integer, nullable=False)
    food_comment = db.Column(db.Text, nullable=True)
    service_score = db.Column(db.Integer, nullable=False)
    service_comment = db.Column(db.Text, nullable=True)
    price_score = db.Column(db.Integer, nullable=False)
    price_comment = db.Column(db.Text, nullable=True)

    # Relationships
    restaurant = db.relationship("Restaurant", backref=db.backref("reviews"))
    user = db.relationship("User", backref=db.backref("reviews"))

    def __repr__(self):
        """Provide helpful representation when printed"""

        return """<Review review_id={} user_id={} 
                    restaurant_id={}>""".format(self.review_id, 
                                                self.user_id,
                                                self.restaurant_id)


class Dish(db.Model):
    """Food dishes on website."""

    __tablename__ = "dishes"

    dish_id = db.Column(db.Integer, autoincrement=True, primary_key=True)
    name = db.Column(db.String(200), nullable=False)

    def __repr__(self):
        """Provide helpful representation when printed"""

        return "<Dish dish_id={} name={}".format(self.dish_id, 
                                                 self.name)


class ReviewDish(db.Model):
    """Middle table to associate reviews and dishes."""

    __tablename__ = "review_dishes"

    review_dish_id = db.Column(db.Integer, autoincrement=True, primary_key=True)
    dish_id = db.Column(db.Integer, db.ForeignKey('dishes.dish_id'))
    review_id = db.Column(db.Integer, db.ForeignKey('reviews.review_id'))
    dish_comment = db.Column(db.Text, nullable=True)

    # Relationships
    review = db.relationship("Review", backref=db.backref("review_dishes"))
    dish = db.relationship("Dish", backref=db.backref("review_dishes"))

    def __repr__(self):
        """Provide helpful representation when printed"""

        return """<ReviewDish id={} dish_id={}
                    review_id={}""".format(self.review_dish_id, 
                                           self.dish_id,
                                           self.review_id)


class RestaurantDish(db.Model):
    """Association table between restaurants and dishes."""

    __tablename__ = "restaurant_dishes"

    restaurant_dish_id = db.Column(db.Integer, autoincrement=True,
                                                primary_key=True)
    dish_id = db.Column(db.Integer, db.ForeignKey('dishes.dish_id'))
    restaurant_id = db.Column(db.String(200),
                                db.ForeignKey('restaurants.restaurant_id'))

    # Relationships
    dish = db.relationship("Dish", backref=db.backref("restaurant_dishes"))
    restaurant = db.relationship("Restaurant",
                                    backref=db.backref("restaurant_dishes"))


    def __repr__(self):
        """Provide helpful representation when printed"""

        return """<RestaurantDish id={} dish_id={}
                    restaurant_id={}""".format(self.restaurant_dish_id, 
                                           self.dish_id,
                                           self.restaurant_id)


##############################################################################
# Helper functions

def connect_to_db(app, db_uri='postgresql:///testdb'):
    """Connect the database to our Flask app."""

    # Configure to use our PostgreSQL database
    app.config['SQLALCHEMY_DATABASE_URI'] = db_uri
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    app.config['SQLALCHEMY_ECHO'] = True
    db.app = app
    db.init_app(app)
    db.create_all()



if __name__ == "__main__":
    # As a convenience, if we run this module interactively, it will leave
    # you in a state of being able to work with the database directly.

    from server import app
    connect_to_db(app)
    print("Connected to DB.")
