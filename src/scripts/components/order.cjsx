Link = ReactRouter.Link

OrderComponent = React.createClass
  contextTypes:
    token: React.PropTypes.string
    order: React.PropTypes.object
    fetchOrder: React.PropTypes.func
    syncOrder: React.PropTypes.func

  childContextTypes:
    nav: React.PropTypes.func
    validateAddress: React.PropTypes.func
    addressValidated: React.PropTypes.bool

  getChildContext: ->
    nav: this.nav
    validateAddress: this.validateAddress
    addressValidated: this.state.addressValidated

  getInitialState: ->
    addressValidated: false

  validateAddress: (bool) ->
    this.setState({ addressValidated: bool })

  componentDidMount: ->
    this.context.fetchOrder()

  nav: (dir, path) ->
    this.context.syncOrder()
    panes = switch
      when _.get(this.context, 'order.sms._enabled')
        ['service_type', 'service_address', 'existing_numbers', 'new_numbers']
      when _.get(this.context, 'order.vs._enabled')
        # ['service_type', 'service_address', 'ip_addresses', 'new_numbers', 'port_numbers', 'number_features', 'review']
        ['service_type', 'service_address', 'new_numbers', 'port_numbers', 'number_features', 'review']
      else
        ['service_type']
    index = _.indexOf(panes, path)
    n = if dir == 'back' then -1 else 1
    this.props.history.push("/order/#{this.props.params.ident}/#{panes[index+n]}")

  linkClass: (path) ->
    order = this.context.order
    classNames path,
      selected: this.props.routes[2] && this.props.routes[2].path == path
      hidden: !order.vs && !order.sms || _.get(this.context, 'order.sms._enabled') && !_.includes(['service_type', 'service_address', 'existing_numbers', 'new_numbers'], path) || _.get(this.context, 'order.vs._enabled') && !_.includes(['service_type', 'service_address', 'ip_addresses', 'new_numbers', 'port_numbers', 'number_features', 'review'], path)

  render: ->
    <div id='order-component'>
      <div id='form'>
        <div className='pane left'>
          <nav>
            <ul>
              <li className={this.linkClass('service_type')}><Link to="/order/#{this.props.params.ident}/service_type">Service Type</Link></li>
              <li className={this.linkClass('service_address')}><Link to="/order/#{this.props.params.ident}/service_address">Service Address</Link></li>
              <li className={this.linkClass('ip_addresses')}><Link to="/order/#{this.props.params.ident}/ip_addresses">IP Addresses</Link></li>
              <li className={this.linkClass('existing_numbers')}><Link to="/order/#{this.props.params.ident}/existing_numbers">Existing Numbers</Link></li>
              <li className={this.linkClass('new_numbers')}><Link to="/order/#{this.props.params.ident}/new_numbers">New Numbers</Link></li>
              <li className={this.linkClass('port_numbers')}><Link to="/order/#{this.props.params.ident}/port_numbers">Port Numbers</Link></li>
              <li className={this.linkClass('number_features')}><Link to="/order/#{this.props.params.ident}/number_features">Number Features</Link></li>
              <li className={this.linkClass('review')}><Link to="/order/#{this.props.params.ident}/review">Quote & Review</Link></li>
            </ul>
          </nav>
          <div className='info'>
            <div className='ident'>Order Number: <span className='em'>{this.props.params.ident}</span></div>
          </div>
        </div>
        <div className='pane right'>
          {this.props.children}
        </div>
      </div>
    </div>
