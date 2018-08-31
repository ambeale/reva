import server
import unittest
import doctest

def load_tests(loader, tests, ignore):
    """Run doctests and file-based doctests."""

    tests.addTests(doctest.DocTestSuite(server))
    return tests


class RouteTestsLoggedOut(unittest.TestCase):

    def setUp(self):
        server.app.config['TESTING'] = True
        self.client = server.app.test_client()

        # Connect to test database
        server.connect_to_db(server.app, "postgresql:///fakedb")

        # Create tables and add sample data
        server.db.create_all()
        server.example_data()


    def test_login_form(self):
        result = self.client.get('/login-form')
        self.assertIn(b'Sign In</h1>',
                        result.data)


    def test_creating_account_successful(self):
        result = self.client.post('/create-account',
                                  data={'email': 'fake@gmail.com',
                                        'fname': 'Test',
                                        'lname': 'Faker',
                                        'password': 'fake123',
                                        'zipcode': '00000'},
                                  follow_redirects=True)
        self.assertIn(b"ve been added!", result.data)


    def test_creating_account_failure(self):
        result = self.client.post('/create-account',
                                  data={'email': 'jane@gmail.com',
                                        'fname': 'Test',
                                        'lname': 'Faker',
                                        'password': 'fake123',
                                        'zipcode': '00000'},
                                  follow_redirects=True)
        self.assertIn(b"Account for this email already created", result.data)


    def test_login_successful(self):
        result = self.client.post('/login',
                                  data={'email': 'jane@gmail.com',
                                        'password': 'hellojane'},
                                  follow_redirects=True)
        self.assertIn(b'Successfully logged in', result.data)


    def test_login_nonexistant_email(self):
        result = self.client.post('/login',
                                  data={'email': 'dne@gmail.com',
                                        'password': 'password'},
                                  follow_redirects=True)
        self.assertIn(b'No user found with that email', result.data)


    def test_login_wrong_password(self):
        result = self.client.post('/login',
                                  data={'email': 'jane@gmail.com',
                                        'password': 'password'},
                                  follow_redirects=True)
        self.assertIn(b'Password incorrect', result.data)

    
    def test_logout(self):
        """Should not have flash message - already logged out"""
        result = self.client.get('/logout', follow_redirects=True)
        self.assertNotIn(b're logged out', result.data)


    def test_display_profile(self):
        result = self.client.get('/profile', follow_redirects=True)
        self.assertIn(b'Please log in to view this page',
                      result.data)

    def test_update_weightings(self):
        result = self.client.post('/update-weightings',
                                   data={'food-weight': 50,
                                         'service-weight': 25,
                                         'price-weight': 25},
                                   follow_redirects=True)
        self.assertIn(b'You must be logged in to update preferences',
                      result.data)

    def test_update_icon(self):
        result = self.client.post('/update-icon',
                                   data={'icon': '/fake/url'},
                                   follow_redirects=True)
        self.assertIn(b'You must be logged in to update preferences',
                      result.data)


class RouteTestsLoggedIn(unittest.TestCase):

    def setUp(self):
        server.app.config['TESTING'] = True
        server.app.config['SECRET_KEY'] = 'key'
        self.client = server.app.test_client()

        # Connect to test database
        server.connect_to_db(server.app, "postgresql:///fakedb")

        # Create tables and add sample data
        server.db.create_all()
        server.example_data()

        with self.client as c:
            with c.session_transaction() as sess:
                sess['user_id'] = 1

    
    def test_login_form(self):
        result = self.client.get('/login-form')
        self.assertNotIn(b'Sign In</h1>',
                        result.data)

    def test_logout(self):
        result = self.client.get('/logout', follow_redirects=True)
        self.assertIn(b're logged out', result.data)


    def test_display_profile(self):
        result = self.client.get('/profile')
        self.assertIn(b'Jane Doe',
                      result.data)


    def test_add_favorite(self):
        add_fav = self.client.post('/update-favorite',
                                  data={'restaurant_id':
                                        'ChIJNZloNTd-j4ARxGMOXZp7KfI'},
                                  follow_redirects=True)

        self.assertIn(b'Favorite added', add_fav.data)

        is_fav = self.client.get('/is-favorite',
                                  query_string={'user_id': '1', 'restaurant': 
                                        'ChIJNZloNTd-j4ARxGMOXZp7KfI'})

        self.assertIn(b'true', is_fav.data)

        remove_fav = self.client.post('/update-favorite',
                                  data={'restaurant_id':
                                        'ChIJNZloNTd-j4ARxGMOXZp7KfI'},
                                  follow_redirects=True)

        self.assertIn(b'Favorite removed', remove_fav.data)

        not_fav = self.client.get('/is-favorite',
                                  query_string={'user_id': '1', 'restaurant': 
                                        'ChIJNZloNTd-j4ARxGMOXZp7KfI'})

        self.assertIn(b'false', not_fav.data)

    def test_update_weightings(self):
        wrong = self.client.post('/update-weightings',
                                   data={'food-weight': 80,
                                         'service-weight': 25,
                                         'price-weight': 25},
                                   follow_redirects=True)
        self.assertIn(b'Score weights must add to 100',
                      wrong.data)

        correct = self.client.post('/update-weightings',
                                   data={'food-weight': 50,
                                         'service-weight': 25,
                                         'price-weight': 25},
                                   follow_redirects=True)
        self.assertIn(b'User preferences updated',
                      correct.data)

    def test_update_icon(self):

        def _mock_add_photo_to_s3(file, user_id):
            return "/fake/S3/url/here"

        server.add_photo_to_s3 = _mock_add_photo_to_s3

        result = self.client.post('/update-icon',
                                   data={'icon': '/fake/url'},
                                   follow_redirects=True)
        self.assertIn(b'User preferences updated', result.data)


class ServerTests(unittest.TestCase):

    def setUp(self):
        server.app.config['TESTING'] = True
        self.client = server.app.test_client()


    def test_index(self):
        result = self.client.get('/')
        self.assertIn(b'Discover your next favorite.',
                        result.data)

    def test_new_account_form(self):
        result = self.client.get('/new-account-form')
        self.assertIn(b'<h2>Create account</h2>',
                        result.data)



if __name__ == '__main__':
    unittest.main()