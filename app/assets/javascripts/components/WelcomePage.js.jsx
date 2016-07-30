
class WelcomePage extends React.Component {

  constructor() {
    super()
    this.state = {}
  }

  cancelRequest() {
    this.setState({
      request: null,
      error: null,
      results: null,
    })
  }

  handleInputChange(event) {
    this.cancelRequest();

    const term = event.target.value;
    if (term.length < 3) {
      return;
    }
    const url = `/searches?search[query]=${encodeURIComponent(term)}`;
    const request = fetch(url);

    this.setState({
      request: request,
    });

    request
      .then((results) => results.json())
      .then((results) => (this.state.request == request) && this.handleFetch(results))
      .catch(this.handleError.bind(this));
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
        <input
          placeholder="Search"
          onChange={this.handleInputChange.bind(this)}
        />
      </div>
    );
  }

}
