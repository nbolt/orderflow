Link = ReactRouter.Link

ServiceAddressComponent = React.createClass
  contextTypes:
    token: React.PropTypes.string
    order: React.PropTypes.object
    updateOrder: React.PropTypes.func
    address: React.PropTypes.object

  validateAddress: (addr) ->
    react = this
    this.setState({ addressValidated: false })
    $.ajax
      url: "http://staging.apeironsys.com/api/address/validate/"
      method: 'POST'
      headers: { Authorization: 'Bearer ' + react.context.token }
      dataType: 'json'
      data: { address: "#{addr.line_1} #{addr.line_2}, #{addr.city}, #{addr.state} #{addr.zip}" }
      success: (rsp) ->
        react.setState({ addresses: rsp }) if rsp[0]

  formUpdate: (ev) ->
    addr = _.get(this.context, 'order.service_addresses.default.full') || this.context.address
    addr[ev.target.name] = ev.target.value
    this.context.updateOrder('service_addresses.default.full', addr)
    this.validateAddress addr

  selectAddress: (address) ->
    addr = { line_1: "#{address.street_number} #{address.route}", line_2: address.subpremise, city: address.city, state: address.state, zip: address.postal_code }
    this.context.updateOrder('service_addresses.default.full', addr)
    this.setState({ addressValidated: true, addresses: [] })

  getInitialState: ->
    addresses:        []
    addressValidated: true

  componentWillMount: ->
    this.validateAddress = _.debounce(this.validateAddress, 500)

  render: ->
    react = this
    addr = _.get(this.context, 'order.service_addresses.default.full') || this.context.address
    disabled = this.context.address

    <div id='service-address'>
      <div className='form'>
        <div className='row'>
          <div className='field full'>
            <input disabled={disabled} name='line_1' placeholder='Line 1' onChange={this.formUpdate} value={addr && addr.line_1} />
          </div>
        </div>
        <div className='row'>
          <div className='field full'>
            <input disabled={disabled} name='line_2' placeholder='Line 2' onChange={this.formUpdate} value={addr && addr.line_2} />
          </div>
        </div>
        <div className='row'>
          <div className='field half'>
            <input disabled={disabled} name='city' placeholder='City' onChange={this.formUpdate} value={addr && addr.city} />
          </div>
          <div className='field eigth'>
            <input disabled={disabled} name='state' placeholder='State' onChange={this.formUpdate} onChange={this.formUpdate} value={addr && addr.state} />
          </div>
          <div className='field quarter'>
            <input disabled={disabled} name='zip' placeholder='Zip' onChange={this.formUpdate} value={addr && addr.zip} />
          </div>
        </div>
        <div className='row addresses'>
          {_.map(this.state.addresses, (address, i) ->
            <div className='address' key={i} onClick={react.selectAddress.bind(null, address)}>{address.complete_address}</div>
          )}
        </div>
      </div>
    </div>