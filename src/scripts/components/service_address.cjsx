Link = ReactRouter.Link

ServiceAddressComponent = React.createClass
  contextTypes:
    order: React.PropTypes.object
    updateOrder: React.PropTypes.func
    address: React.PropTypes.object

  formUpdate: (ev) ->
    addr = this.context.address || {}
    addr[ev.target.name] = ev.target.value
    this.context.updateOrder('service_addresses.default.full', addr)
    

  render: ->
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
      </div>
    </div>