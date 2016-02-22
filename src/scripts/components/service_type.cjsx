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

  selected: (path) ->
    classNames
      selected: _.get(this.context.order, path)

  backClass: ->
    'hidden'

  continueClass: ->
    'hidden' if !_.get(this.context, 'order.vs._enabled') && !_.get(this.context, 'order.sms._enabled') || _.get(this.context, 'order.vs._enabled') && !_.get(this.context, 'order.vs._service_direction.in') && !_.get(this.context, 'order.vs._service_direction.out') && !_.get(this.context, 'order.vs._service_direction.bi')

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
          </div>
          <div className='sms'></div>
        </div>
      </div>
      <div className='foot'>
        <ul className='links'>
          <li className={this.backClass()}><a href='javascript:void(0)' onClick={this.nav.bind(null, 'back')}>Back</a></li>
          <li className={this.continueClass()}><a href='javascript:void(0)' onClick={this.nav.bind(null, 'continue')}>Continue</a></li>
        </ul>
      </div>
    </div>