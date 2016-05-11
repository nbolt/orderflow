NewNumbersComponent = React.createClass
  contextTypes:
    ident: React.PropTypes.string
    token: React.PropTypes.string
    order: React.PropTypes.object
    nav: React.PropTypes.func
    updateOrder: React.PropTypes.func

  searchNumbers: ->
    react = this
    data = { list_id: this.context.ident }
    switch this.state.tab
      when 'did'
        switch this.state.did.search
          when 'city'
            data.rate_center = this.state.did.city
            data.state       = this.state.did.state
          when 'npa'
            data.npa = this.state.did.npa
            data.nxx = this.state.did.nxx
      when 'tfn'
        switch this.state.tfn.search
          when 'npa'
            data.npa = this.state.tfn.npa
            data.nxx = ''
    if data.rate_center && data.state || this.state.tab == 'did' && data.npa && data.nxx || this.state.tab == 'tfn' && data.npa
      react.setState({ loading: true })
      $.ajax
        url: 'http://staging.apeironsys.com/api/number_search'
        method: 'GET'
        headers: { Authorization: 'Bearer ' + react.context.token }
        dataType: 'json'
        data: data
        success: (rsp) ->
          react.setState({ loading: false })
          if rsp[0]
            switch react.state.tab
              when 'did'
                did = react.state.did
                did.numbers = rsp
                react.setState({ did: did })
              when 'tfn'
                tfn = react.state.tfn
                tfn.numbers = rsp
                react.setState({ tfn: tfn })

  reserveNumber: (number) ->
    react = this
    $.ajax
      url: "http://staging.apeironsys.com/api/number_search/reserve/#{number}/#{this.context.ident}"
      method: 'GET'
      headers: { Authorization: 'Bearer ' + react.context.token }
      dataType: 'json'
      success: (rsp) ->
        nums = _.map(rsp, (n) -> { number: n, type: react.numType(n) })
        react.context.updateOrder([['vs.in.all', nums]], true)
        react.selectNumber number

  unreserveNumber: (number) ->
    react = this
    $.ajax
      url: "http://staging.apeironsys.com/api/number_search/unreserve/#{number}/#{this.context.ident}"
      method: 'GET'
      headers: { Authorization: 'Bearer ' + react.context.token }
      dataType: 'json'
      success: (rsp) ->
        nums = _.map(rsp, (n) -> { number: n, type: react.numType(n) })
        react.context.updateOrder([['vs.in.all', nums]], true)
        react.removeNumber number

  numType: (number) ->
    if number[0..2] in ['800', '888', '877', '866', '855', '844']
      'tfn'
    else
      'did'

  selectNumber: (number) ->
    numbers  = _.filter(this.state[this.numType(number)].numbers, (n) -> n != number)
    selected = _.concat(this.state[this.numType(number)].selected, number)
    type     = this.numType number
    this.setNumbers type, numbers, selected

  removeNumber: (number) ->
    selected = _.filter(this.state[this.numType(number)].selected, (n) -> n != number)
    numbers  = _.concat(this.state[this.numType(number)].numbers, number)
    type     = this.numType number
    this.setNumbers type, numbers, selected

  setNumbers: (type, numbers, selected) ->
    obj          = this.state[type]
    obj.numbers  = numbers
    obj.selected = selected
    switch type
      when 'tfn'
        this.setState({ tfn: obj })
      when 'did'
        this.setState({ did: obj })

  tab: (pane) -> this.setState({ tab: pane })

  didFieldChange: (field, data) ->
    did   = this.state.did
    did[field] = data && data.value
    this.setState({ did: did })
    this.searchNumbers()

  tfnFieldChange: (field, data) ->
    tfn   = this.state.tfn
    tfn[field] = data && data.value
    this.setState({ tfn: tfn })
    this.searchNumbers()

  didSearchTab: (pane) ->
    did = this.state.did
    did.search = pane
    this.setState({ did: did })
    this.searchNumbers()

  tfnSearchTab: (pane) ->
    tfn = this.state.tfn
    tfn.search = pane
    this.setState({ tfn: tfn })
    this.searchNumbers()

  backClass: ->

  continueClass: ->

  footClass: ->
    react = this
    classNames 'foot',
      hidden: !react.state.tab

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
      hidden: !react.state.tab || react.state.did.search != pane

  didSearchTabClass: (tab) ->
    react = this
    classNames 'search-tab',
      selected: tab == react.state.did.search

  tfnSearchPaneClass: (pane) ->
    react = this
    classNames 'tfn-search-pane', pane,
      hidden: !react.state.tab || react.state.tfn.search != pane


  tfnSearchTabClass: (tab) ->
    react = this
    classNames 'search-tab',
      selected: tab == react.state.tfn.search


  loadingClass: ->
    react = this
    classNames 'loading',
      hidden: !react.state.loading

  didStates: -> [
    { value: 'TX', label: 'Texas' }
  ]

  didCities: ->
    switch this.state.did.state
      when 'TX'
        [
          { value: 'Cisco', label: 'Cisco' }
        ]

  didNpas: ->
    _.map([818, 562], (n) -> { value: n, label: n })

  didNxxs: ->
    switch this.state.did.npa
      when 818
        _.map([338, 661], (n) -> { value: n, label: n })
      when 562
        _.map([391, 742], (n) -> { value: n, label: n })

  tfnNpas: ->
    _.map([888], (n) -> { value: n, label: n })

  getInitialState: ->
    loading: false
    tab: null
    did:
      numbers: []
      selected: []
      search: null
      city: null
      state: null
      npa: null
      nxx: null
    tfn:
      numbers: []
      selected: []
      search: null
      npa: null

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
                <Select value={this.state.did.state} options={this.didStates()} onChange={this.didFieldChange.bind(null, 'state')}/>
                <Select value={this.state.did.city} options={this.didCities()} onChange={this.didFieldChange.bind(null, 'city')}/>
              </div>
              <div className={this.didSearchPaneClass('npa')}>
                <Select value={this.state.did.npa} options={this.didNpas()} onChange={this.didFieldChange.bind(null, 'npa')}/>
                <Select value={this.state.did.nxx} options={this.didNxxs()} onChange={this.didFieldChange.bind(null, 'nxx')}/>
              </div>
            </div>
            <div className={this.loadingClass()}>loading...</div>
          </div>
          <div className='column results'>
            <div className='title'>Search Results</div>
            <div className='numbers'>
              {_.map(this.state.did.numbers, (number, i) ->
                <div className='number' key={i} onClick={react.reserveNumber.bind(null, number)}>{number}</div>
              )}
            </div>
          </div>
          <div className='column selection'>
            <div className='title'>Selected Numbers</div>
            <div className='numbers'>
              {_.map(this.state.did.selected, (number, i) ->
                <div className='number' key={i} onClick={react.unreserveNumber.bind(null, number)}>{number}</div>
              )}
            </div>
          </div>
        </div>
        <div className={this.paneClass('tfn')}>
          <div className='column parameters'>
            <div className='title'>Search Criteria</div>
            <div className='search-tabs'>
              <div className={this.tfnSearchTabClass('npa')} onClick={this.tfnSearchTab.bind(null, 'npa')}>NPA / NXX</div>
            </div>
            <div className='search-panes'>
              <div className={this.tfnSearchPaneClass('npa')}>
                <Select value={this.state.tfn.npa} options={this.tfnNpas()} onChange={this.tfnFieldChange.bind(null, 'npa')}/>
              </div>
            </div>
            <div className={this.loadingClass()}>loading...</div>
          </div>
          <div className='column results'>
            <div className='title'>Search Results</div>
            <div className='numbers'>
              {_.map(this.state.tfn.numbers, (number, i) ->
                <div className='number' key={i} onClick={react.reserveNumber.bind(null, number)}>{number}</div>
              )}
            </div>
          </div>
          <div className='column selection'>
            <div className='title'>Selected Numbers</div>
            <div className='numbers'>
              {_.map(this.state.tfn.selected, (number, i) ->
                <div className='number' key={i} onClick={react.unreserveNumber.bind(null, number)}>{number}</div>
              )}
            </div>
          </div>
        </div>
      </div>
      <div className={this.footClass()}>
        <ul className='links'>
          <li className={this.backClass()}><a href='javascript:void(0)' onClick={this.context.nav.bind(null, 'back', this.props.route.path)}>Back</a></li>
          <li className={this.continueClass()}><a href='javascript:void(0)' onClick={this.context.nav.bind(null, 'continue', this.props.route.path)}>Continue</a></li>
        </ul>
      </div>
    </div>
