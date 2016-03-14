ServiceAddressComponent = React.createClass
  contextTypes:
    token: React.PropTypes.string
    order: React.PropTypes.object
    nav: React.PropTypes.func
    updateOrder: React.PropTypes.func
    syncOrder: React.PropTypes.func
    address: React.PropTypes.object
    validateAddress: React.PropTypes.func
    addressValidated: React.PropTypes.bool

  validateAddress: ->
    react = this
    react.context.validateAddress(false)
    addr = this.state.address
    $.ajax
      url: "http://staging.apeironsys.com/api/address/validate/"
      method: 'POST'
      headers: { Authorization: 'Bearer ' + react.context.token }
      dataType: 'json'
      data: { address: "#{addr.line_1} #{addr.line_2}, #{addr.city}, #{addr.state} #{addr.zip}" }
      success: (rsp) ->
        if rsp[0]
          addresses = _.filter(rsp, (addr) -> addr.city && addr.state && addr.postal_code && addr.street_number && addr.route)
          react.setState({ addresses: addresses })

  selectAddress: (address) ->
    addr = { line_1: "#{address.street_number} #{address.route}", line_2: address.subpremise, city: address.city, state: address.state, zip: address.postal_code }
    this.context.updateOrder([['service_addresses.default.full', addr]])
    this.context.validateAddress true
    this.setState({ addresses: [] })

  modifyAddress: ->
    this.context.validateAddress false

  formUpdate: (ev) ->
    addr = this.state.address
    addr[ev.target.name] = ev.target.value
    this.setState({ address: addr })

  getInitialState: ->
    address:   {}
    addresses: []

  componentDidMount: ->
    react = this
    n = undefined
    wait = setInterval((->
      n ||= 0
      n = n+1
      clearInterval wait if n > 20
      if _.get(react.context, 'order.service_addresses')
        clearInterval wait
        addr = _.get(react.context, 'order.service_addresses.default.full') || react.context.address ||
          line_1: null
          line_2: null
          city:   null
          state:  null
          zip:    null
        react.setState({ address: addr })
        react.context.validateAddress(true) if _.get(react.context, 'order.service_addresses.default.full') || react.context.address
    ), 100)

  disabled: -> this.context.address || this.context.addressValidated

  backClass: ->

  continueClass: ->
    'hidden' unless this.context.addressValidated

  modifyClass: ->
    'hidden' unless this.context.addressValidated

  validateClass: ->
    'hidden' if this.context.addressValidated

  render: ->
    react = this
    <div id='service-address'>
      <div className='viewport'>
        <div className='form'>
          <div className='row'>
            <div className='field full'>
              <input disabled={this.disabled()} name='line_1' placeholder='Line 1' onChange={this.formUpdate} value={this.state.address.line_1} />
            </div>
          </div>
          <div className='row'>
            <div className='field full'>
              <input disabled={this.disabled()} name='line_2' placeholder='Line 2' onChange={this.formUpdate} value={this.state.address.line_2} />
            </div>
          </div>
          <div className='row'>
            <div className='field half'>
              <input disabled={this.disabled()} name='city' placeholder='City' onChange={this.formUpdate} value={this.state.address.city} />
            </div>
            <div className='field eigth'>
              <input disabled={this.disabled()} name='state' placeholder='State' onChange={this.formUpdate} value={this.state.address.state} />
            </div>
            <div className='field quarter'>
              <input disabled={this.disabled()} name='zip' placeholder='Zip' onChange={this.formUpdate} value={this.state.address.zip} />
            </div>
          </div>
          <div className='row addresses'>
            {_.map(this.state.addresses, (address, i) ->
              <div className='address' key={i} onClick={react.selectAddress.bind(null, address)}>{address.complete_address}</div>
            )}
          </div>
        </div>
      </div>
      <div className='foot'>
        <ul className='links'>
          <li className={this.backClass()}><a href='javascript:void(0)' onClick={this.context.nav.bind(null, 'back', this.props.route.path)}>Back</a></li>
          <li className={this.validateClass()}><a href='javascript:void(0)' onClick={this.validateAddress}>Validate</a></li>
          <li className={this.modifyClass()}><a href='javascript:void(0)' onClick={this.modifyAddress}>Modify</a></li>
          <li className={this.continueClass()}><a href='javascript:void(0)' onClick={this.context.nav.bind(null, 'continue', this.props.route.path)}>Continue</a></li>
        </ul>
      </div>
    </div>
