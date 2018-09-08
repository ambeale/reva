"""Utility file to seed review database with data in fake_data/"""

from sqlalchemy import func
from datetime import datetime
import random
import bcrypt
from model import Restaurant, User, Review, Photo, Dish, ReviewDish, RestaurantDish
from model import connect_to_db, db
from server import app


def load_restaurants():
    """Load testing restaurants into database"""
    print("Restaurants")

    with open("fake_data/restaurants.txt") as text:
        for row in text:
            row = row.rstrip()
            restaurant_id, name, number, address, website, lat, lon = row.split("|")

            restaurant = Restaurant(restaurant_id=restaurant_id,
                                    name=name, 
                                    phone_number=number, 
                                    address=address, 
                                    website=website,
                                    lat=lat,
                                    lon=lon)

            # Add to the session or it won't be stored
            db.session.add(restaurant)

    db.session.commit()


def load_users():
    """Load fake users into database."""

    print("Users")

    # Delete all rows in table, so if we need to run this a second time,
    # we won't be trying to add duplicate users
    User.query.delete()

    url1= "https://images.unsplash.com/photo-"
    url2 = "?crop=entropy&fm=jpg&w=150&h=150&fit=crop"

    icons = ["1491273289208-9340cb42e5d9", "1520618825575-e632cb001d53",
             "1525640788966-69bdb028aa73", "1504283708523-52171518259f",
             "1523986490752-c28064f26be3", "1464347744102-11db6282f854",
             "1524097676851-f5f2eda28d2c", "1528277787110-35213c499081",
             "1530071711643-d02e3fad31a2", "1459486358775-edfe3fb98c36"]

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
                        zipcode=zipcode,
                        icon=url1 + icons.pop() + url2)

            # Add to the session or it won't be stored
            db.session.add(user)

    # commit when done
    db.session.commit()


def load_reviews():
    """Load fake reviews into database."""

    print("Reviews")
    dates = [datetime(2018,3,14), datetime(2017,11,3), datetime(2018,1,26),
             datetime(2018,7,27), datetime(2018,8,6), datetime(2018,5,4),
             datetime(2017,12,30), datetime(2018,1,16), datetime(2017,10,14),
             datetime(2018,6,27)]

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

            if restaurant_id =='ChIJNZloNTd-j4ARxGMOXZp7KfI':
                review = Review(created_at=dates.pop(),
                                user_id=user_id,
                                restaurant_id=restaurant_id,
                                food_score=food_score,
                                food_comment=food_comment,
                                service_score=service_score,
                                service_comment=service_comment,
                                price_score=price_score,
                                price_comment=price_comment)
            else:
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


def load_photos():
    """Link photos to some reviews"""

    url1 = 'https://reva-photo-uploads.s3.amazonaws.com/photo-'
    url2 = '.jpeg'
    photos = ['1534422298391-e4f8c172dddb','1532420633514-05d9096b4fb3',
              '1534476429-dc25f72aa33b','1490474418585-ba9bad8fd0ea',
              '1519233991914-26a44330ccd7','1490645935967-10de6ba17061',
              '1535400255456-984241443b29','1476224203421-9ac39bcb3327',
              '1532744535173-f6b6d2da1fcb','1522080213597-473dfd70215c']

    # Get Farmhouse Kitchen reviews
    reviews = Review.query.filter_by(restaurant_id='ChIJNZloNTd-j4ARxGMOXZp7KfI')

    for review in reviews:
        for n in range(random.randint(0,3)):
            if not photos:
                break
            photo = Photo(review_id=review.review_id, url=url1+photos.pop()+url2)
            db.session.add(photo)

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
    load_restaurants()
    load_users()
    set_val_user_id()
    load_reviews()
    load_photos()
    load_dishes()
    set_val_dish_id()
    load_middle_tables()