Link = ReactRouter.Link

OrderComponent = React.createClass
  contextTypes:
    token: React.PropTypes.string
    order: React.PropTypes.object
    fetchOrder: React.PropTypes.func
    syncOrder: React.PropTypes.func

  childContextTypes:
    nav: React.PropTypes.func
    home: React.PropTypes.func
    continueText: React.PropTypes.func

  getChildContext: ->
    nav: this.nav
    home: this.home
    continueText: this.continueText

  componentDidMount: ->
    this.context.fetchOrder()

  home: -> this.props.history.push("/order/#{this.props.params.ident}")

  displayPane:
    service_type: 'Service Type'
    service_address: 'Service Address'
    existing_numbers: 'Existing Numbers'
    ip_addresses: 'IP Addresses'
    new_numbers: 'New Numbers'
    trunk_config: 'Trunk Configuration'
    port_numbers: 'Port Numbers'
    number_features: 'Number Features'
    review: 'Quote & Review'

  continueText: (path) ->
    panes = switch
      when _.get(this.context, 'order.sms._enabled')
        ['service_type', 'service_address', 'existing_numbers', 'new_numbers']
      when _.get(this.context, 'order.vs._enabled')
        ['service_type', 'service_address', 'ip_addresses', 'trunk_config', 'new_numbers', 'port_numbers', 'number_features', 'review']
      else
        ['service_type', 'service_address']
    index = _.indexOf(panes, path)
    pane = this.displayPane[panes[index+1]]
    "Continue to #{pane}"

  nav: (dir, path) ->
    react = this
    this.context.syncOrder(->
      panes = switch
        when _.get(react.context, 'order.sms._enabled')
          ['service_type', 'service_address', 'existing_numbers', 'new_numbers']
        when _.get(react.context, 'order.vs._enabled')
          ['service_type', 'service_address', 'ip_addresses', 'trunk_config', 'new_numbers', 'port_numbers', 'number_features', 'review']
        else
          ['service_type']
      index = _.indexOf(panes, path)
      n = if dir == 'back' then -1 else 1
      react.props.history.push("/order/#{react.props.params.ident}/#{panes[index+n]}")
    )

  linkClass: (path) ->
    order = this.context.order
    classNames path,
      selected: this.props.routes[2] && this.props.routes[2].path == path
      hidden: !order.vs && !order.sms || _.get(this.context, 'order.sms._enabled') && !_.includes(['service_type', 'service_address', 'existing_numbers', 'new_numbers'], path) || _.get(this.context, 'order.vs._enabled') && !_.includes(['service_type', 'service_address', 'ip_addresses', 'trunk_config', 'new_numbers', 'port_numbers', 'number_features', 'review'], path)

  render: ->
    <div id='order-component'>
      <div id='form'>
        <div className='pane left'>
          <nav>
            <ul>
              <li className={this.linkClass('service_type')}><Link to="/order/#{this.props.params.ident}/service_type">Service Type</Link></li>
              <li className={this.linkClass('service_address')}><Link to="/order/#{this.props.params.ident}/service_address">Service Address</Link></li>
              <li className={this.linkClass('ip_addresses')}><Link to="/order/#{this.props.params.ident}/ip_addresses">IP Addresses</Link></li>
              <li className={this.linkClass('trunk_config')}><Link to="/order/#{this.props.params.ident}/trunk_config">Trunk Configuration</Link></li>
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
