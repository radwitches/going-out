
class WelcomePage extends React.Component {

  constructor() {
    super()
    this.state = {}
    window.gMaps().then(() => this.setState({google: window.google}))
  }

  cancelRequest() {
    this.setState({
      request: null,
      error: null,
      results: null,
    })
  }

  handleInputChange(event) {
    let {lat, lng} = event.location
    this.setState({lat, lng})
  }

  handleError(xhr) {
    // Only show errors if it's for the current request.
    if (this.state.request == xhr) {
      this.setState({
        request: null,
        error: xhr.statusText,
      });
    }
  }

  handleFetch(results) {
    this.setState({
      request: null,
      results: results,
    })
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
        {this.state.lat}, {this.state.lng}
      </div>
    );
  }

}
