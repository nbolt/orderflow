Modal = ReactModal

ServiceAddressComponent = React.createClass
  contextTypes:
    token: React.PropTypes.string
    domain: React.PropTypes.string
    headers: React.PropTypes.object
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
      url: "#{react.context.domain}/api/address/validate/"
      method: 'POST'
      headers: react.context.headers
      dataType: 'json'
      data: { address1: "#{addr.line_1}", address2: "#{addr.line_2}", city: "#{addr.city}", state: "#{addr.state}", zip_code: "#{addr.zip}" }
      success: (rsp) ->
        if rsp[0]
          addresses = _.filter(rsp, (addr) -> addr.city && addr.state && addr.postal_code && addr.street_number && addr.route)
          if addresses[0]
            react.setState({ addresses: addresses, modal: true })

  selectAddress: (address) ->
    addr = { line_1: "#{address.street_number} #{address.route}", line_2: address.subpremise, city: address.city, state: address.state, zip: address.postal_code }
    this.context.updateOrder([['service_addresses.default.full', addr]])
    this.context.validateAddress true
    this.setState({ addresses: [], modal: false })

  releaseAddress: ->
    this.context.validateAddress false

  formUpdate: (ev) ->
    addr = this.state.address
    addr[ev.target.name] = ev.target.value
    this.setState({ address: addr })

  getInitialState: ->
    modal: false
    address:   {}
    addresses: []

  componentDidMount: ->
    react = this
    n = undefined
    wait = setInterval((->
      n ||= 0
      n = n+1
      clearInterval wait if n > 20
      if _.get(react.context, 'order.service_addresses') || react.context.address
        clearInterval wait
        addr = _.get(react.context, 'order.service_addresses.default.full') || react.context.address ||
          line_1: null
          line_2: null
          city:   null
          state:  null
          zip:    null
        react.setState({ address: addr })
        react.context.validateAddress(true)
    ), 100)

  disabled: -> this.context.address || this.context.addressValidated

  backClass: ->

  continueClass: ->
    'hidden' unless this.context.addressValidated

  validateClass: ->
    'hidden' if this.context.addressValidated

  releaseClass: ->
    react = this
    classNames
      hidden: react.context.address || !react.context.addressValidated

  verifyClass: ->
    react = this
    classNames 'remodal-confirm',
      hidden: !react.state.selectedAddress

  addrClass: (address) ->
    react = this
    classNames 'address',
      selected: react.state.selectedAddress == address

  validatedClass: ->
    react = this
    classNames 'validated',
      hidden: !react.context.addressValidated

  address: ->
    addr = _.get(this.context, 'order.service_addresses.default.full') || this.context.address
    if addr
      "#{addr.line_1} #{addr.line_2} #{addr.city} #{addr.state} #{addr.zip}"
    else
      null

  render: ->
    react = this
    <div id='service-address'>
      <Modal className='address' isOpen={this.state.modal}>
        <h1>Address Verification</h1>
        <div className='addresses'>
          {_.map(this.state.addresses, (address, i) ->
            <div className={react.addrClass(address)} key={i} onClick={react.selectAddress.bind(null, address)}>{address.complete_address}</div>
          )}
        </div>
      </Modal>
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
        </div>
        <div className={this.validatedClass()}>
          <div className='label'>Validated Address:</div>
          <div className='address'>{this.address()}</div>
        </div>
      </div>
      <div className='foot'>
        <ul className='links'>
          <li className={this.backClass()}><a href='javascript:void(0)' onClick={this.context.nav.bind(null, 'back', this.props.route.path)}>Back</a></li>
          <li className={this.validateClass()}><a href='javascript:void(0)' onClick={this.validateAddress}>Validate</a></li>
          <li className={this.releaseClass()}><a href='javascript:void(0)' onClick={this.releaseAddress}>Release</a></li>
          <li className={this.continueClass()}><a href='javascript:void(0)' onClick={this.context.nav.bind(null, 'continue', this.props.route.path)}>Continue</a></li>
        </ul>
      </div>
    </div>
