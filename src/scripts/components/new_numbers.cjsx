NewNumbersComponent = React.createClass
  contextTypes:
    token: React.PropTypes.string
    order: React.PropTypes.object
    nav: React.PropTypes.func
    updateOrder: React.PropTypes.func

  addNumbers: ->
    selected = _.map(['1234567890'], (n) -> { number: n, type: 'did',  })
    this.context.updateOrder([['vs.in.all', selected]])

  searchNumbers: (city=false, state=false) ->
    react = this
    react.setState({ loading: true })
    $.ajax
      url: 'http://staging.apeironsys.com/api/number_search'
      method: 'GET'
      headers: { Authorization: 'Bearer ' + react.context.token }
      dataType: 'json'
      data:
        list_id: react.context.order.id
        rate_center: city || react.state.didCity
        state: state || react.state.didState
      success: (rsp) ->
        react.setState({ loading: false })
        react.setState({ numbers: rsp }) if rsp[0]

  refreshNumbers: -> this.searchNumbers()

  selectNumber: (number) ->
    numbers  = _.filter(this.state.numbers, (n) -> n != number)
    selected = _.concat(this.state.selected, number)
    this.setState({ numbers: numbers, selected: selected })

  removeNumber: (number) ->
    selected = _.filter(this.state.selected, (n) -> n != number)
    numbers  = _.concat(this.state.numbers, number)
    this.setState({ numbers: numbers, selected: selected })

  didCityChange: (data) -> this.setState({ didCity: data.value }); this.searchNumbers(data.value)

  tab: (pane) -> this.setState({ tab: pane })

  didSearchTab: (pane) -> this.setState({ didSearchTab: pane })

  backClass: ->

  continueClass: ->

  refreshClass: ->

  tabClass: (tab) ->
    react = this
    classNames 'tab',
      selected: tab == react.state.tab

  paneClass: (pane) ->
    react = this
    classNames 'tab-pane', pane,
      hidden: !react.state.tab || react.state.tab != pane

  didSearchPaneClass: (pane) ->
    react = this
    classNames 'did-search-pane', pane,
      hidden: !react.state.tab || react.state.didSearchTab != pane

  didSearchTabClass: (tab) ->
    react = this
    classNames 'search-tab',
      selected: tab == react.state.didSearchTab

  loadingClass: ->
    react = this
    classNames 'loading',
      hidden: !react.state.loading

  didCities: [
    { value: 'CISCO', label: 'Cisco, TX' }
  ]

  getInitialState: ->
    loading: false
    numbers: []
    selected: []
    tab: null
    didSearchTab: null
    didCity: 'CISCO'
    didState: 'TX'

  render: ->
    react = this
    <div id='new-numbers'>
      <div className='tabs'>
        <div className={this.tabClass('did')} onClick={this.tab.bind(null, 'did')}>DID Search</div>
        <div className={this.tabClass('tfn')} onClick={this.tab.bind(null, 'tfn')}>TFN Search</div>
      </div>
      <div className='tab-content'>
        <div className={this.paneClass('did')}>
          <div className='column parameters'>
            <div className='title'>Search Criteria</div>
            <div className='search-tabs'>
              <div className={this.didSearchTabClass('city')} onClick={this.didSearchTab.bind(null, 'city')}>City / State</div>
              <div className={this.didSearchTabClass('npa')} onClick={this.didSearchTab.bind(null, 'npa')}>NPA / NXX</div>
            </div>
            <div className='search-panes'>
              <div className={this.didSearchPaneClass('city')}>
                <Select value={this.state.didCity} options={this.didCities} onChange={this.didCityChange}/>
              </div>
              <div className={this.didSearchPaneClass('npa')}>
              </div>
            </div>
            <div className={this.loadingClass()}>loading...</div>
          </div>
          <div className='column results'>
            <div className='title'>Search Results</div>
            <div className='numbers'>
              {_.map(this.state.numbers, (number, i) ->
                <div className='number' key={i} onClick={react.selectNumber.bind(null, number)}>{number}</div>
              )}
            </div>
          </div>
          <div className='column selection'>
            <div className='title'>Selected Numbers</div>
            <div className='numbers'>
              {_.map(this.state.selected, (number, i) ->
                <div className='number' key={i} onClick={react.removeNumber.bind(null, number)}>{number}</div>
              )}
            </div>
          </div>
        </div>
        <div className={this.paneClass('tfn')}>
          <div className='column parameters'>
            <div className='title'>Search Criteria</div>
          </div>
          <div className='column results'>
            <div className='title'>Search Results</div>
          </div>
          <div className='column selection'>
            <div className='title'>Selected Numbers</div>
          </div>
        </div>
      </div>
      <div className='hidden foot'>
        <ul className='links'>
          <li className={this.backClass()}><a href='javascript:void(0)' onClick={this.context.nav.bind(null, 'back', this.props.route.path)}>Back</a></li>
          <li className={this.refreshClass()}><a href='javascript:void(0)' onClick={this.refreshNumbers}>Refresh</a></li>
          <li className={this.continueClass()}><a href='javascript:void(0)' onClick={this.context.nav.bind(null, 'continue', this.props.route.path)}>Continue</a></li>
        </ul>
      </div>
    </div>
