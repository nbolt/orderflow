Link = ReactRouter.Link

ServiceTypeComponent = React.createClass
  contextTypes:
    order: React.PropTypes.object
    syncOrder: React.PropTypes.func
    updateOrder: React.PropTypes.func

  nav: (dir) ->
    this.context.syncOrder()
    panes = ['service_type', 'service_address', 'ip_addresses', 'new_numbers', 'port_numbers', 'number_features', 'review']
    index = _.indexOf(panes, this.props.route.path)
    n = if dir == 'back' then -1 else 1
    this.props.history.push("/order/#{this.props.params.ident}/#{panes[index+n]}")

  updateInput: (path, ev) ->
    this.context.updateOrder([[path, parseInt(ev.target.value) || null]])

  selected: (path) ->
    classNames
      selected: _.get(this.context.order, path)

  backClass: ->
    'hidden'

  continueClass: ->
    hidden = false

    hidden = true if !_.get(this.context, 'order.vs._enabled') && !_.get(this.context, 'order.sms._enabled')
    hidden = true if _.get(this.context, 'order.vs._enabled') && !_.get(this.context, 'order.vs._service_direction.in') && !_.get(this.context, 'order.vs._service_direction.out') && !_.get(this.context, 'order.vs._service_direction.bi')
    hidden = true if _.get(this.context, 'order.vs._enabled') && !_.get(this.context, 'order.vs.in.call_paths')

    hidden = true if _.get(this.context, 'order.sms._enabled') && !_.get(this.context, 'order.sms._service_type.phone_number') && !_.get(this.context, 'order.sms._service_type.shortcode')
    hidden = true if _.get(this.context, 'order.sms._enabled') && (!_.get(this.context, 'order.sms.capacity.in') || !_.get(this.context, 'order.sms.capacity.out'))

    'hidden' if hidden

  render: ->
    voice = classNames
      selected: _.get(this.context, 'order.vs._enabled')
    sms   = classNames
      selected: _.get(this.context, 'order.sms._enabled')

    <div id='service-type'>
      <div className='viewport'>
        <div className='options'>
          <div className={this.selected('vs._enabled') + ' type'} onClick={this.context.updateOrder.bind(null, [['vs._enabled', true], ['sms._enabled', false]], false)}>Voice</div>
          <div className={this.selected('sms._enabled') + ' type'} onClick={this.context.updateOrder.bind(null, [['vs._enabled', false], ['sms._enabled', true]], false)}>SMS</div>
        </div>
        <div className='type-containers'>
          <div className={voice + ' vs container'}>
            <div className='options'>
              <div className={this.selected('vs._service_direction.out') + ' type'} onClick={this.context.updateOrder.bind(null, [['vs._service_direction.out', true], ['vs._service_direction.in', false], ['vs._service_direction.bi', false]], false)}>Oubound</div>
              <div className={this.selected('vs._service_direction.in') + ' type'} onClick={this.context.updateOrder.bind(null, [['vs._service_direction.out', false], ['vs._service_direction.in', true], ['vs._service_direction.bi', false]], false)}>Inbound</div>
              <div className={this.selected('vs._service_direction.bi') + ' type'} onClick={this.context.updateOrder.bind(null, [['vs._service_direction.out', false], ['vs._service_direction.in', false], ['vs._service_direction.bi', true]], false)}>Bidirectional</div>
            </div>
            <div className='call_paths'>
              <input value={_.get(this.context, 'order.vs.in.call_paths')} onChange={this.updateInput.bind(null, 'vs.in.call_paths')} type='text' placeholder='Call Paths'/>
            </div>
          </div>
          <div className={sms + ' sms container'}>
            <div className='options'>
              <div className={this.selected('sms.service_type.phone_number') + 'type'} onClick={this.context.updateOrder.bind(null, [['sms._service_type.phone_number', true], ['sms._service_type.shortcode', false]])}>Phone Number</div>
              <div className={this.selected('sms._service_type.shortcode') + ' type'} onClick={this.context.updateOrder.bind(null, [['sms._service_type.phone_number', false], ['sms._service_type.shortcode', true]])}>Shortcode</div>
            </div>
            <div className='message-volume'>
              <input value={_.get(this.context, 'order.sms.capacity.in')} onChange={this.updateInput.bind(null, 'sms.capacity.in')} type='text' placeholder='Messages/sec in'/>
              <input value={_.get(this.context, 'order.sms.capacity.out')} onChange={this.updateInput.bind(null, 'sms.capacity.out')} type='text' placeholder='Messages/sec out'/>
            </div>
          </div>
        </div>
      </div>
      <div className='foot'>
        <ul className='links'>
          <li className={this.backClass()}><a href='javascript:void(0)' onClick={this.nav.bind(null, 'back')}>Back</a></li>
          <li className={this.continueClass()}><a href='javascript:void(0)' onClick={this.nav.bind(null, 'continue')}>Continue</a></li>
        </ul>
      </div>
    </div>