class FavoriteClicker extends React.Component {
  constructor() {
    super();
    this.state = { value: heart };

    this.addFavorite = this.addFavorite.bind(this);
    this.notLoggedIn = this.notLoggedIn.bind(this);
    this.favSuccess = this.favSuccess.bind(this);
  }

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

  notLoggedIn() {
    alert("You must be logged in to save a favorite.");
  }

  favSuccess(result) {
    alert(result);
    if (result === "Favorite added") {
      heart = 'fas fa-heart';
    } else {
      heart = 'far fa-heart';
    }
    this.setState({ value: heart });
  }

  addFavorite() {
    if (userId !== "None") {
      $.post("/update-favorite", 
        {"restaurant_id": restaurantId},
        this.favSuccess);
    } else {
      this.notLoggedIn();
    }
  }

  render() {
    return (
      <span className={this.state.value} onClick={this.addFavorite}></span>
    );
  }
}

const userId = document.querySelector('#fav').getAttribute('loggedin');
const restaurantId = document.querySelector('#fav').getAttribute('rest');
let heart = 'far fa-heart';


ReactDOM.render(
  <FavoriteClicker />,
  document.getElementById('fav')
);