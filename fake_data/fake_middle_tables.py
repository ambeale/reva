from faker import Faker
import random

fake = Faker()

restaurants = ['ChIJNZloNTd-j4ARxGMOXZp7KfI',
                 'ChIJfcaly4eAhYARSIvvfFpH64w',
                 'ChIJlfC_eYKAhYARhcWC559q0jc',
                 'ChIJVRnYLHyAhYARhl2ZVJFi5iU',
                 'ChIJ5UiqQJCAhYAR5L5rAgjuf_0',
                 'ChIJKT_dq7GAhYARpHV3vs0HUWQ',
                 'ChIJMygdeCZ-j4ARKDtpQiICwUo',
                 'ChIJzf0lTbCAhYARqz-tqaIyJaY',
                 'ChIJh_24QJ-AhYAR_xbUNVN2Xns',
                 'ChIJk8dm4J6AhYAR8MCM6inxTgE']


for i in range(10):
    dish_id = i + 1

    for j in range(10):
        review_id = random.randint(1,100)
        dish_comment = fake.paragraph()

        print("""{}|{}|{}""".format(dish_id, review_id, dish_comment))