
class WelcomePage extends React.Component {

  constructor() {
    super()
    this.state = {parks: []}
    window.gMaps().then(() => this.setState({google: window.google}))
  }

  handleInputChange(event) {
    this.setState({parks: []})
    this.setState({location: event.location});
    let {lat, lng} = event.location;
    fetch(`/near?lat=${lat}&lng=${lng}`).
      then((resp) => resp.json()).
      then((parks) =>
        this.setState({parks: parks})
      )
  }

  render() {
    return (
      <div className="WelcomePage">
        { this.state.google &&
        <GeoSuggestionInput
          onSuggestSelect={this.handleInputChange.bind(this)}
          location={new google.maps.LatLng(-37, 145)}
        />
        }

        {this.state.location &&
        <span>{this.state.location.lat}, {this.state.location.lng}</span>
        }
        {this.state.parks.map((park, idx) =>
          <div key={idx}>
            {idx} {park.name} {JSON.stringify(park.amenities)}
          </div>
        )}
      </div>
    );
  }

}
