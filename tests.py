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
        self.assertIn(b'<h2>User Login</h2>',
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
        self.assertNotIn(b'<h2>User Login</h2>',
                        result.data)

    def test_logout(self):
        result = self.client.get('/logout', follow_redirects=True)
        self.assertIn(b're logged out', result.data)


    def test_display_profile(self):
        result = self.client.get('/profile')
        self.assertIn(b'Jane Doe',
                      result.data)


class ServerTests(unittest.TestCase):

    def setUp(self):
        server.app.config['TESTING'] = True
        self.client = server.app.test_client()


    def test_index(self):
        result = self.client.get('/')
        self.assertIn(b'<h2>Welcome to the Review App (RevA)!</h2>',
                        result.data)

    def test_new_account_form(self):
        result = self.client.get('/new-account-form')
        self.assertIn(b'<h2>Create account</h2>',
                        result.data)

if __name__ == '__main__':
    unittest.main()