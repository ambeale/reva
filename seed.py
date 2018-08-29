"""Utility file to seed review database with data in fake_data/"""

from sqlalchemy import func
from datetime import datetime
import bcrypt
from model import User, Review, Dish, ReviewDish, RestaurantDish
from model import connect_to_db, db
from server import app


# IMPORTANT: Be sure to run psql [db_name] < fake_data/restaurants.pg 
#            before seed.py file to seed with restaurants from Google API

def load_users():
    """Load fake users into database."""

    print("Users")

    # Delete all rows in table, so if we need to run this a second time,
    # we won't be trying to add duplicate users
    User.query.delete()

    # Read user file and insert data
    with open("fake_data/fake_users.txt") as text:
        for row in text:
            row = row.rstrip()
            user_id, email, fname, lname, password, zipcode = row.split("|")
            
            # Hash password using bcrypt
            salt = bcrypt.gensalt()
            hashed_password = bcrypt.hashpw(password.encode('utf-8'), salt)
            
            user = User(user_id=user_id,
                        email=email,
                        fname=fname,
                        lname=lname,
                        password=hashed_password.decode('utf-8'),
                        zipcode=zipcode)

            # Add to the session or it won't be stored
            db.session.add(user)

    # commit when done
    db.session.commit()


def load_reviews():
    """Load fake reviews into database."""

    print("Reviews")

    # Read review file and insert data
    with open("fake_data/fake_reviews.txt") as text:
        for row in text:
            row = row.rstrip()
            (user_id,
             restaurant_id,
             food_score,
             food_comment,
             service_score,
             service_comment,
             price_score,
             price_comment) = row.split("|")

            review = Review(user_id=user_id,
                            restaurant_id=restaurant_id,
                            food_score=food_score,
                            food_comment=food_comment,
                            service_score=service_score,
                            service_comment=service_comment,
                            price_score=price_score,
                            price_comment=price_comment)

            db.session.add(review)

    db.session.commit()

def load_dishes():
    """Load fake dishes into database."""

    print("Dishes")

    with open("fake_data/fake_dishes.txt") as text:
        for row in text:
            row = row.rstrip()

            dish_id, dish = row.split("|")

            dish = Dish(dish_id=dish_id,name=dish)

            db.session.add(dish)

    db.session.commit()


def load_middle_tables():
    """Load fake data into middle tables"""

    print("Middle tables")

    # Read dishes file and insert data
    with open("fake_data/fake_middle_tables.txt") as text:
        for row in text:
            row = row.rstrip()

            (dish_id,
              dish,
              review_id,
              dish_comment) = row.split("|")

            query = Review.query.filter_by(review_id=review_id).first()
            restaurant_id = query.restaurant_id
            
            review_dish = ReviewDish(dish_id=dish_id,
                                     review_id=review_id,
                                     dish_comment=dish_comment)
            
            restaurant_dish = RestaurantDish(dish_id=dish_id,
                                             restaurant_id=restaurant_id)

            db.session.add_all([review_dish, restaurant_dish])

    db.session.commit()


def set_val_user_id():
    """Set value for the next user_id after seeding database"""

    # Get the Max user_id in the database
    result = db.session.query(func.max(User.user_id)).one()
    max_id = int(result[0])

    # Set the value for the next user_id to be max_id
    query = "SELECT setval('users_user_id_seq', :new_id)"
    db.session.execute(query, {'new_id': max_id})
    db.session.commit()


def set_val_dish_id():
    """Set value for the next dish_id after seeding database"""

    # Get the Max dish_id in the database
    result = db.session.query(func.max(Dish.dish_id)).one()
    max_id = int(result[0])

    # Set the value for the next dish_id to be max_id
    query = "SELECT setval('dishes_dish_id_seq', :new_id)"
    db.session.execute(query, {'new_id': max_id})
    db.session.commit()


if __name__ == "__main__":
    connect_to_db(app)

    # In case tables haven't been created, create them
    db.create_all()

    # Import different types of data
    load_users()
    set_val_user_id()
    load_reviews()
    load_dishes()
    set_val_dish_id()
    load_middle_tables()