// Allow user to favorite or unfavorite restaurants

class FavoriteClicker extends React.Component {
  constructor() {
    super();
    this.state = { value: heartEmpty };

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
          this.setState({ value: heartFilled });
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
      this.setState({ value: heartFilled });
    } else {
      this.setState({ value: heartEmpty });
    }
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
let heartEmpty = 'far fa-heart';
let heartFilled = 'fas fa-heart';


ReactDOM.render(
  <FavoriteClicker />,
  document.getElementById('fav')
);