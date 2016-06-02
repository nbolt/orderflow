PortNumbersComponent = React.createClass
  contextTypes:
    token: React.PropTypes.string
    nav: React.PropTypes.func
    order: React.PropTypes.object
    updateOrder: React.PropTypes.func

  invoice: -> $('#upload').click()

  upload: ->
    react = this
    data = new FormData()
    data.append('file', $('#upload').get(0).files[0]);
    $.ajax
      url: 'http://staging.apeironsys.com/api/files/upload/'
      method: 'POST'
      headers: { Authorization: 'Bearer ' + react.context.token }
      dataType: 'json'
      contentType: false
      processData: false
      cache: false
      data: data
      success: (rsp) ->
        order = react.state.order
        order.invoices.push({ id: rsp[0]['id'], filename: rsp[0]['filename'] })
        this.setState({ order: order })

  removeNumber: (number) ->
    react = this
    _.each(this.context.order.vs.in.portorders, (order, i) ->
      react.context.updateOrder([["vs.in.portorders[#{i}].numbers", _.filter(order.numbers, (n) -> n != number)]], false)
    )

  updateField: (field, ev) ->
    order = this.state.order
    order[field] = ev.target.value
    this.setState({ order: order })

  updateOrder: (key, value) ->
    order = this.state.order
    order[key] = value
    this.setState({ order: order })

  updateRawNumbers: (ev) -> this.setState({ raw_numbers: ev.target.value })

  submit: ->
    react = this
    this.state.order.numbers = _.map(this.state.raw_numbers.split("\n"), (n) -> n.replace(/\D/g, ''))
    this.context.updateOrder([["vs.in.portorders[#{this.context.order.vs.in.portorders.length}]", this.state.order]], true)
    this.setState({ order: {numbers:[]}, raw_numbers: '' })

  selected: (key, value) ->
    react = this
    classNames
      selected: react.state.order[key] == value

  tab: (pane) -> this.setState({ tab: pane })

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

  getInitialState: ->
    tab: 'port'
    order: {numbers: [], invoices: []}

  render: ->
    react = this
    <div id='port-numbers'>
      <div className='viewport'>
        <div className='tabs'>
          <div className={this.tabClass('port')} onClick={this.tab.bind(null, 'did')}>TFN & DID Port</div>
        </div>
        <div className='tab-content'>
          <div className={this.paneClass('port')}>
            <div className='column entry'>
              <div className='title'>Number Entry</div>
              <div className='content'>
                <div className='options'>
                  <div className='title'>Type:</div>
                  <div className={this.selected('type', 'tfn') + ' type'} onClick={this.updateOrder.bind(null, 'type', 'tfn')}>Toll Free</div>
                  <div className={this.selected('type', 'did') + ' type'} onClick={this.updateOrder.bind(null, 'type', 'did')}>DID</div>
                </div>
                <div className='options'>
                  <div className='title'>Billing Number:</div>
                  <input type='text' value={this.state.order.btn} onChange={this.updateField.bind(null, 'btn')}/>
                </div>
                <div className='options'>
                  <div className='title'>Full / Partial Port:</div>
                  <div className={this.selected('full', true) + ' type'} onClick={this.updateOrder.bind(null, 'full', true)}>Full</div>
                  <div className={this.selected('full', false) + ' type'} onClick={this.updateOrder.bind(null, 'full', false)}>Partial</div>
                </div>
              </div>
              <div className='input'>
                <textarea value={this.state.raw_numbers} onChange={this.updateRawNumbers} rows='6' placeholder='Input number list, one per line.'></textarea>
              </div>
              <div className='provider-info'>
                <input type='text' placeholder='Current Provider' value={this.state.order.provider}/>
                <input type='text' placeholder='Authorization Name' value={this.state.order.name}/>
                <input type='text' placeholder='Provider Address' value={this.state.order.address}/>
                <input type='text' placeholder='PIN Number (if known)' value={this.state.order.pin}/>
              </div>
              <div className='submit'>
                <div className='links'>
                  <div className='link' onClick={this.invoice}>Upload Invoice</div>
                  <div className='link' onClick={this.submit}>Submit Numbers to Order</div>
                </div>
                <input id='upload' type='file' onChange={this.upload}/>
              </div>
            </div>
            <div className='column list'>
              <div className='title'>Numbers to Port</div>
              <div className='numbers'>
                {_.map(_.get(this.context.order, 'vs.in.portorders'), (order, i) ->
                  _.map(order.numbers, (number, i) ->
                    <div className='number' key={i} onClick={react.removeNumber.bind(null, number)}>{number}</div>
                  )
                )}
              </div>
            </div>
          </div>
        </div>
      </div>
      <div className='foot'>
        <ul className='links'>
          <li className={this.backClass()}><a href='javascript:void(0)' onClick={this.context.nav.bind(null, 'back', this.props.route.path)}>Back</a></li>
          <li className={this.continueClass()}><a href='javascript:void(0)' onClick={this.context.nav.bind(null, 'continue', this.props.route.path)}>Continue</a></li>
        </ul>
      </div>
    </div>
