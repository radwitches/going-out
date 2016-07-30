
class WelcomePage extends React.Component {

  constructor() {
    super()
    this.state = {}
    window.gMaps().then(() => this.setState({google: window.google}))
  }

  handleInputChange(event) {
    this.setState({location: event.location})
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
      </div>
    );
  }

}
