Link = ReactRouter.Link

OrderComponent = React.createClass
  contextTypes:
    token: React.PropTypes.string.isRequired
    order: React.PropTypes.func
    fetchOrder: React.PropTypes.func.isRequired
    router: React.PropTypes.func.isRequired
    
  childContextTypes:
    order: React.PropTypes.object
    updateOrder: React.PropTypes.func

  syncOrder: ->
    react = this
    $.ajax
      url: "http://staging.apeironsys.com/api/_flow/orders/#{react.props.params.ident}"
      method: 'PUT'
      headers: { Authorization: 'Bearer ' + react.context.token }
      dataType: 'json'
      contentType: 'application/json'
      data: JSON.stringify({ order: react.context.order })

  nav: (dir) ->
    this.syncOrder()
    index = $('#form .pane.left li.selected').index()
    len = $('#form .pane.left li').length
    if dir == 'back'
      index = len if index == 0
      pane  = $('#form .pane.left li:eq(' + (index-1) + ')').attr('class')
    else
      index = -1 if index == (len-1)
      pane  = $('#form .pane.left li:eq(' + (index+1) + ')').attr('class')
    this.props.history.push("/order/#{this.props.params.ident}/#{pane}")

  componentDidMount: ->
    this.context.fetchOrder()

  render: ->
    react = this
    linkClass = (path) -> classNames path,
      selected: react.props.routes[2] && react.props.routes[2].path == path

    <div id='order-component'>
      <div id='form'>
        <div className='pane left'>
          <nav>
            <ul>
              <li className={linkClass('service_type')}><Link to="/order/#{this.props.params.ident}/service_type">Service Type</Link></li>
              <li className={linkClass('service_address')}><Link to="/order/#{this.props.params.ident}/service_address">Service Address</Link></li>
              <li className={linkClass('ip_addresses')}><Link to="/order/#{this.props.params.ident}/ip_addresses">IP Addresses</Link></li>
              <li className={linkClass('new_numbers')}><Link to="/order/#{this.props.params.ident}/new_numbers">New Numbers</Link></li>
              <li className={linkClass('port_numbers')}><Link to="/order/#{this.props.params.ident}/port_numbers">Port Numbers</Link></li>
              <li className={linkClass('number_features')}><Link to="/order/#{this.props.params.ident}/number_features">Number Features</Link></li>
              <li className={linkClass('review')}><Link to="/order/#{this.props.params.ident}/review">Quote & Review</Link></li>
            </ul>
          </nav>
          <div className='info'>
            <div className='ident'>Order Number: <span className='em'>{this.props.params.ident}</span></div>
          </div>
        </div>
        <div className='pane right'>
          <div className='viewport'>{this.props.children}</div>
          <div className='foot'>
            <ul className='links'>
              <li><a href='javascript:void(0)' onClick={this.nav.bind(null, 'back')}>Back</a></li>
              <li><a href='javascript:void(0)' onClick={this.nav.bind(null, 'continue')}>Continue</a></li>
            </ul>
          </div>
        </div>
      </div>
    </div>