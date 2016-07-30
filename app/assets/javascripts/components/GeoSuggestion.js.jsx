class GeoSuggestionItem extends React.Component {
  constructor(props) {
    super(props);
  }

  handleClick(event) {
    event.preventDefault();
    if (this.props.onSuggestSelect) {
      this.props.onSuggestSelect(this.props.suggest);
    }
  }

  render() {
    return (
      <li className={'geosuggest-item' + (this.props.isActive ? ' geosuggest-item--active' : '')} onClick={this.handleClick.bind(this)}>
        {this.props.suggest.label}
      </li>
    );
  }
}


class GeoSuggestionInput extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      isSuggestsHidden: true,
      userInput: '',
      activeSuggest: null,
      suggests: [],
      geocoder: new google.maps.Geocoder(),
      autocompleteService: new google.maps.places.AutocompleteService(),
    };
  }

  updateAutocomplete() {
    if (!this.state.userInput.length) {
      return this.updateSuggests();
    }

    this.state.autocompleteService.getPlacePredictions({
      input: this.state.userInput,
      location: this.props.location || new google.maps.LatLng(0, 0),
      radius: this.props.radius || 0,
    }, (suggestions) => this.updateSuggests(suggestions));

  }

  handleInputChange(e) {
    this.setState({userInput: e.target.value}, () => this.updateAutocomplete());
  }

  handleInputFocus() {
    this.updateSuggests();
    this.setState({isSuggestsHidden: false});
  }

  handleInputBlur() {
    setTimeout(() => {
      this.setState({isSuggestsHidden: true});
    }, 100);
  }

  handleInputKeyDown(event){
    switch (event.which) {
      case 40: // DOWN
        event.preventDefault();
        this.activateSuggest('next');
        break;
      case 38: // UP
        event.preventDefault();
        this.activateSuggest('prev');
        break;
      case 13: // ENTER
        this.handleSuggestSelect(this.state.activeSuggest);
        this.handleInputBlur();
        break;
      case 9: // TAB
        this.handleSuggestSelect(this.state.activeSuggest);
        this.handleInputBlur();
        break;
      case 27: // ESC
        this.handleInputBlur();
        break;
    }
  }

  handleSuggestSelect(suggest) {
    if (!suggest) {
      suggest = {
        label: this.state.userInput,
      };
    }

    this.setState({
      isSuggestsHidden: true,
      userInput: suggest.label,
    });

    if (suggest.location && this.props.onSuggestSelect) {
      this.props.onSuggestSelect(suggest);
      return;
    }

    this.geocodeSuggest(suggest);
  }

  updateSuggests(suggestsGoogle) {
    let suggests = [];
    let regex = new RegExp(this.state.userInput, 'gim');

    (this.props.fixtures || []).forEach((suggest) => {
      if (suggest.label.match(regex)) {
        suggest.placeId = suggest.label;
        suggests.push(suggest);
      }
    });

    (suggestsGoogle || []).forEach((suggest) => {
      suggests.push({
        label: suggest.description,
        placeId: suggest.place_id,
      });
    });

    this.setState({suggests});
  }

  activateSuggest(direction) {
    let suggestsCount = this.state.suggests.length - 1;
    let next = (direction === 'next');
    let newActiveSuggest = null;
    let newIndex = 0;

    for (let i = 0; i <= suggestsCount; i++) {
      if (this.state.suggests[i] === this.state.activeSuggest) {
        newIndex = next ? i + 1 : i - 1;
      }
    }

    if (!this.state.activeSuggest) {
      newIndex = next ? 0 : suggestsCount;
    }

    if (newIndex >= 0 && newIndex <= suggestsCount) {
      newActiveSuggest = this.state.suggests[newIndex];
    }

    this.setState({activeSuggest: newActiveSuggest});
  }

   geocodeSuggest(suggest) {
    this.state.geocoder.geocode({
      address: suggest.label,
    }, (results, status) => {

      if (status !== google.maps.GeocoderStatus.OK) { return; }

      let location = results[0].geometry.location;
      suggest.location = {
        lat: location.lat(),
        lng: location.lng(),
      };

      this.handleSuggestSelect(suggest);
     });
  }

  getSuggestItems(){
    return this.state.suggests.map((suggest) => {
      let isActive = (this.state.activeSuggest && suggest.placeId === this.state.activeSuggest.placeId);

      return (
        <GeoSuggestionItem
          key={suggest.placeId}
          suggest={suggest}
          isActive={isActive}
          onSuggestSelect={this.handleSuggestSelect && this.handleSuggestSelect.bind(this)}
         />
      );
    });
  }

  render() {
    return (
      <div className="geosuggest">
        <input
          className="geosuggest__input"
          ref="geosuggestInput"
          type="text"
          value={this.state.userInput}
          placeholder={this.props.placeholder || ''}
          onKeyDown={this.handleInputKeyDown.bind(this)}
          onChange={this.handleInputChange.bind(this)}
          onFocus={this.handleInputFocus.bind(this)}
          onBlur={this.handleInputBlur.bind(this)}
        />
        <ul className={'geosuggest__suggests' + (this.state.isSuggestsHidden ? ' geosuggest__suggests--hidden' : '')}>
          {this.getSuggestItems()}
        </ul>
      </div>
    );
  }
}
