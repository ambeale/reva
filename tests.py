import server
import unittest
import doctest

def load_tests(loader, tests, ignore):
    """Run doctests and file-based doctests."""

    tests.addTests(doctest.DocTestSuite(server))
    return tests


class MyAppIntegrationTestCase(unittest.TestCase):

    def setUp(self):
        self.client = server.app.test_client()
        server.app.config['TESTING'] = True

    def test_index(self):
        result = self.client.get('/')
        self.assertIn(b'<h2>Welcome to the Review App (RevA)!</h2>', result.data)


if __name__ == '__main__':
    unittest.main()