from faker import Faker
fake = Faker()


# print("user_id|email|fname|lname|password|zipcode")

for n in range(1,11):
    user_id = n
    email = fake.email()
    fname = fake.first_name()
    lname = fake.last_name()
    password = 'password'
    zipcode = fake.postalcode()

    print("""{}|{}|{}|{}|{}|{}""".format(user_id, email, fname, lname,
                                         password, zipcode))