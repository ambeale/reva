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

for i in range(1,11):
    user_id = i

    for j in range(10):
        restaurant_id = restaurants[j]
        food_score = random.randint(1,5)
        food_comment = fake.paragraph()
        service_score = random.randint(1,5)
        service_comment = fake.paragraph()
        price_score = random.randint(1,5)
        price_comment = fake.paragraph()

        print("""{}|{}|{}|{}|{}|{}|{}|{}""".format(user_id,
                                             restaurant_id,
                                             food_score,
                                             food_comment,
                                             service_score,
                                             service_comment,
                                             price_score,
                                             price_comment))