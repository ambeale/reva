// Allow user to favorite or unfavorite restaurants

class FavoriteClicker extends React.Component {
  constructor() {
    super();
    this.state = { value: heart };

    this.addFavorite = this.addFavorite.bind(this);
    this.notLoggedIn = this.notLoggedIn.bind(this);
    this.favSuccess = this.favSuccess.bind(this);
  }

  // Set initial heart to filled if already a user's favorite
  componentDidMount() {
    if (userId !== "None") {
      fetch(`/is-favorite?restaurant=${restaurantId}&user_id=${userId}`)
      .then(response => response.json())
      .then(data => {
        if (data === true) {
          heart = 'fas fa-heart';
          this.setState({ value: heart });
        }
      })
    }
  }

  // Handle user click on heart
  addFavorite() {
    if (userId !== "None") {
      $.post("/update-favorite", 
        {"restaurant_id": restaurantId},
        this.favSuccess);
    } else {
      this.notLoggedIn();
    }
  }

  // Alert after click if user if not logged in
  notLoggedIn() {
    alert("You must be logged in to save a favorite.");
  }

  // Update heart icon as restaurant favorited / unfavorited
  favSuccess(result) {
    if (result === "Favorite added") {
      heart = 'fas fa-heart';
    } else {
      heart = 'far fa-heart';
    }
    this.setState({ value: heart });
  }

  render() {
    return (
      <span className={this.state.value} onClick={this.addFavorite}></span>
    );
  }
}


// Get user_id and restaurant_id HTML attributes
const userId = document.querySelector('#fav').getAttribute('loggedin');
const restaurantId = document.querySelector('#fav').getAttribute('rest');

// Set empty heart as default
let heart = 'far fa-heart';


ReactDOM.render(
  <FavoriteClicker />,
  document.getElementById('fav')
);