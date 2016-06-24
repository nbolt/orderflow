NewNumbersComponent = React.createClass
  contextTypes:
    ident: React.PropTypes.string
    token: React.PropTypes.string
    domain: React.PropTypes.string
    headers: React.PropTypes.object
    order: React.PropTypes.object
    nav: React.PropTypes.func
    updateOrder: React.PropTypes.func
    continueText: React.PropTypes.func

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
            data.nxx = this.state.tfn.nxx
    if data.rate_center && data.state || this.state.tab == 'did' && data.npa && data.nxx || this.state.tab == 'tfn' && data.npa
      react.setState({ loading: true })
      $.ajax
        url: "#{react.context.domain}/api/number_search"
        method: 'GET'
        headers: react.context.headers
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
      url: "#{react.context.domain}/api/number_search/reserve/#{number}/#{this.context.ident}"
      method: 'GET'
      headers: react.context.headers
      dataType: 'json'
      success: (rsp) ->
        nums = _.map(rsp, (n) -> { number: n, type: react.numType(n) })
        react.context.updateOrder([['vs.in.all', nums]], true)
        react.selectNumber number

  unreserveNumber: (number) ->
    react = this
    $.ajax
      url: "#{react.context.domain}/api/number_search/unreserve/#{number}/#{this.context.ident}"
      method: 'GET'
      headers: react.context.headers
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

  selectChange: (type, field, data) ->
    state = this.state
    type = state[type]
    type[field] = data && data.value
    this.setState state

  fieldChange: (type, field, ev) ->
    state = this.state
    type = state[type]
    type[field] = ev.target.value
    this.setState state

  searchTab: (type, pane) ->
    state = this.state
    type  = state[type]
    type.search = pane
    this.setState state

  backClass: ->

  continueClass: ->

  tabClass: (tab) ->
    react = this
    classNames 'tab',
      selected: tab == react.state.tab

  paneClass: (pane) ->
    react = this
    classNames 'tab-pane', pane,
      hidden: !react.state.tab || react.state.tab != pane

  searchPaneClass: (type, pane) ->
    react = this
    classNames "#{type}-search-pane", pane,
      hidden: !react.state.tab || react.state[type].search != pane

  searchTabClass: (type, tab) ->
    react = this
    classNames 'search-tab',
      selected: tab == react.state[type].search

  loadingClass: ->
    react = this
    classNames 'loading',
      hidden: !react.state.loading

  didStates: -> [
    { value: 'AL', label: 'Alabama' },
    { value: 'AK', label: 'Alaska' },
    { value: 'AZ', label: 'Arizona' },
    { value: 'AR', label: 'Arkansas' },
    { value: 'CA', label: 'California' },
    { value: 'CO', label: 'Colorado' },
    { value: 'CT', label: 'Connecticut' },
    { value: 'DE', label: 'Delaware' },
    { value: 'FL', label: 'Florida' },
    { value: 'GA', label: 'Georgia' },
    { value: 'HI', label: 'Hawaii' },
    { value: 'ID', label: 'Idaho' },
    { value: 'IL', label: 'Illinois' },
    { value: 'IN', label: 'Indiana' },
    { value: 'IA', label: 'Iowa' },
    { value: 'KS', label: 'Kansas' },
    { value: 'KY', label: 'Kentucky' },
    { value: 'LA', label: 'Louisiana' },
    { value: 'ME', label: 'Maine' },
    { value: 'MD', label: 'Maryland' },
    { value: 'MA', label: 'Massachusetts' },
    { value: 'MI', label: 'Michigan' },
    { value: 'MN', label: 'Minnesota' },
    { value: 'MS', label: 'Mississippi' },
    { value: 'MO', label: 'Missouri' },
    { value: 'MT', label: 'Montana' },
    { value: 'NE', label: 'Nebraska' },
    { value: 'NV', label: 'Nevada' },
    { value: 'NH', label: 'New Hampshire' },
    { value: 'NJ', label: 'New Jersey' },
    { value: 'NM', label: 'New Mexico' },
    { value: 'NY', label: 'New York' },
    { value: 'NC', label: 'North Carolina' },
    { value: 'ND', label: 'North Dakota' },
    { value: 'OH', label: 'Ohio' },
    { value: 'OK', label: 'Oklahoma' },
    { value: 'OR', label: 'Oregon' },
    { value: 'PA', label: 'Pennsylvania' },
    { value: 'RI', label: 'Rhode Island' },
    { value: 'SC', label: 'South Carolina' },
    { value: 'SD', label: 'South Dakota' },
    { value: 'TN', label: 'Tennessee' },
    { value: 'TX', label: 'Texas' },
    { value: 'UT', label: 'Utah' },
    { value: 'VT', label: 'Vermont' },
    { value: 'VA', label: 'Virginia' },
    { value: 'WA', label: 'Washington' },
    { value: 'WV', label: 'West Virginia' },
    { value: 'WI', label: 'Wisconsin' },
    { value: 'WY', label: 'Wyoming' },
    { value: 'DC', label: 'District of Columbia' }
  ]

  dids: ->
    react = this
    _.filter(_.get(react.context.order, 'vs.in.all'), (n) -> !_.includes(['800', '888', '877', '866', '855', '844'], _.take(n.number, 3).join('')))

  tfns: ->
    react = this
    _.filter(_.get(react.context.order, 'vs.in.all'), (n) -> _.includes(['800', '888', '877', '866', '855', '844'], _.take(n.number, 3).join('')))

  getInitialState: ->
    loading: false
    tab: null
    did:
      numbers: []
      search: null
      city: null
      state: null
      npa: null
      nxx: null
    tfn:
      numbers: []
      search: null
      npa: null
      nxx: null

  render: ->
    react = this
    <div id='new-numbers'>
      <div className='viewport'>
        <div className='tabs'>
          <div className={this.tabClass('did')} onClick={this.tab.bind(null, 'did')}>DID Search</div>
          <div className={this.tabClass('tfn')} onClick={this.tab.bind(null, 'tfn')}>TFN Search</div>
        </div>
        <div className='tab-content'>
          <div className={this.paneClass('did')}>
            <div className='column parameters'>
              <div className='title'>Search Criteria</div>
              <div className='search-tabs'>
                <div className={this.searchTabClass('did', 'city')} onClick={this.searchTab.bind(null, 'did', 'city')}>City / State</div>
                <div className={this.searchTabClass('did', 'npa')} onClick={this.searchTab.bind(null, 'did', 'npa')}>NPA / NXX</div>
              </div>
              <div className='search-panes'>
                <div className={this.searchPaneClass('did', 'city')}>
                  <Select value={this.state.did.state} options={this.didStates()} onChange={this.selectChange.bind(null, 'did', 'state')}/>
                  <div className='field text full'>
                    <input type='text' placeholder='City' value={this.state.did.city} onChange={this.fieldChange.bind(null, 'did', 'city')}/>
                  </div>
                </div>
                <div className={this.searchPaneClass('did', 'npa')}>
                  <div className='field text'>
                    <input type='text' placeholder='NPA' value={this.state.did.npa} onChange={this.fieldChange.bind(null, 'did', 'npa')}/>
                  </div>
                  <div className='field text'>
                    <input type='text' placeholder='NXX' value={this.state.did.nxx} onChange={this.fieldChange.bind(null, 'did', 'nxx')}/>
                  </div>
                </div>
              </div>
              <div className='search' onClick={this.searchNumbers}>Search</div>
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
                {_.map(react.dids(), (n, i) ->
                  <div className='number' key={i} onClick={react.unreserveNumber.bind(null, n.number)}>{n.number}</div>
                )}
              </div>
            </div>
          </div>
          <div className={this.paneClass('tfn')}>
            <div className='column parameters'>
              <div className='title'>Search Criteria</div>
              <div className='search-tabs'>
                <div className={this.searchTabClass('tfn', 'npa')} onClick={this.searchTab.bind(null, 'tfn', 'npa')}>NPA / NXX</div>
              </div>
              <div className='search-panes'>
                <div className={this.searchPaneClass('tfn', 'npa')}>
                  <div className='field text'>
                    <input type='text' placeholder='NPA' value={this.state.tfn.npa} onChange={this.fieldChange.bind(null, 'tfn', 'npa')}/>
                  </div>
                  <div className='field text'>
                    <input type='text' placeholder='NXX' value={this.state.tfn.nxx} onChange={this.fieldChange.bind(null, 'tfn', 'nxx')}/>
                  </div>
                </div>
              </div>
              <div className='search' onClick={this.searchNumbers}>Search</div>
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
                {_.map(react.tfns(), (n, i) ->
                  <div className='number' key={i} onClick={react.unreserveNumber.bind(null, n.number)}>{n.number}</div>
                )}
              </div>
            </div>
          </div>
        </div>
      </div>
      <div className='foot'>
        <ul className='links'>
          <li className={this.backClass()}><a href='javascript:void(0)' onClick={this.context.nav.bind(null, 'back', this.props.route.path)}>Back</a></li>
          <li className={this.continueClass()}><a href='javascript:void(0)' onClick={this.context.nav.bind(null, 'continue', this.props.route.path)}>{this.context.continueText('new_numbers')}</a></li>
        </ul>
      </div>
    </div>
