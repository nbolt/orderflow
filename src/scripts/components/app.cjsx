Link = ReactRouter.Link

AppComponent = React.createClass
  childContextTypes:
    ident: React.PropTypes.string
    token: React.PropTypes.string
    domain: React.PropTypes.string
    headers: React.PropTypes.object
    errors: React.PropTypes.array
    errClass: React.PropTypes.func
    hintClass: React.PropTypes.func
    hintContent: React.PropTypes.func
    cost: React.PropTypes.array
    address: React.PropTypes.object
    addressValidated: React.PropTypes.bool
    validateAddress: React.PropTypes.func
    order: React.PropTypes.object
    fetchOrder: React.PropTypes.func
    updateOrder: React.PropTypes.func
    removeArrayElement: React.PropTypes.func
    syncOrder: React.PropTypes.func

  getChildContext: ->
    ident: this.props.params.ident
    token: this.state.token
    domain: this.state.domain
    headers: this.state.headers
    errors: this.state.errors
    errClass: this.errClass
    hintClass: this.hintClass
    hintContent: this.hintContent
    cost: this.state.cost
    address: this.state.address
    addressValidated: this.state.addressValidated
    validateAddress: this.validateAddress
    order: this.state.order || {}
    fetchOrder: this.fetchOrder
    updateOrder: this.updateOrder
    removeArrayElement: this.removeArrayElement
    syncOrder: this.syncOrder

  validateAddress: (bool) -> this.setState({ addressValidated: bool })

  errClass: (field) ->
    err = false
    _.each(this.state.errors, (o) ->
      _.each(o, (v,k) ->
        err = true if field == k
      )
    )
    classNames
      err: err

  hintClass: (field) ->
    hint = false
    _.each(this.state.errors, (o) ->
      _.each(o, (v,k) ->
        hint = true if field == k
      )
    )
    classNames
      'hint--right': hint,
      'hint--medium': hint,
      'hint--error': hint,
      'hint--rounded': hint

  hintContent: (field) ->
    content = ''
    _.each(this.state.errors, (o) ->
      _.each(o, (v,k) ->
        content = v if field == k
      )
    )
    content

  newOrder: ->
    react = this
    $.ajax
      url: "#{react.state.domain}/api/_flow/orders"
      method: 'POST'
      headers: react.state.headers
      dataType: 'json'
      success: (rsp) ->
        react.setState({ addressValidated: false })
        react.props.history.push("/order/#{rsp.ident}/service_type")
        react.fetchOrder()

  fetchOrder: ->
    react = this
    $.ajax
      url: "#{react.state.domain}/api/_flow/orders/#{react.props.params.ident}"
      method: 'GET'
      headers: react.state.headers
      dataType: 'json'
      success: (rsp) ->
        first = if react.state.order then false else true
        react.setState({ order: rsp.order })
        react.syncOrder() if first

  syncOrder: (cb) ->
    react = this
    this.setState({ errors: [] })
    $.ajax
      url: "#{react.state.domain}/api/_flow/orders/#{react.props.params.ident}"
      method: 'PUT'
      headers: react.state.headers
      dataType: 'json'
      contentType: 'application/json'
      data: JSON.stringify({ order: react.state.order })
      success: (rsp, w) ->
        react.setState({ cost: rsp['cost'] }) if rsp['cost']
        cb() if cb
      error: (rsp) ->
        rsp = rsp['responseJSON']
        if _.isArray(rsp)
          react.setState({ errors: rsp })
          react.err rsp[0][Object.keys(rsp[0])[0]]

  err: (msg) ->
    $('nav .err').html msg
    $('nav .err').addClass 'display'
    setTimeout((->
      $('nav .err').removeClass 'display'
    ), 5000)

  updateOrder: (values, sync=false) ->
    order = this.state.order || {status: 'in_progress', vs:{_enabled:false,call_paths:100,_cpsin:20,_cpsout:20,codec:{rtp:{G711u64K:true, G729a:false, G722:false},dtmf:{RFC2833:true, inband:false},fax:{T38Fallback:true, T38:false, G711:false}},apeironIPprimary:{ip:'66.85.56.10/32',port:'5060'},apeironIPsecondary:{ip:'66.85.57.10/32',port:'5060'},in:{all:[],trunk:{entries:[]},portorders:[]}},sms:{_enabled:false,_mpsin:1,_mpsout:1}}
    _.each(values, (v) -> _.set(order, v[0], v[1]))
    _.set(order, 'vs.in.trunk.inbound_checked', false) unless _.get(order, 'vs._service_direction.bi')
    this.setState({ order: order })
    this.syncOrder() if sync

  removeArrayElement: (values, sync=false) ->
    order = this.state.order
    _.each(values, (v) -> _.remove(_.get(order, v[0]), (e,i) -> v[1] == i))
    this.setState({ order: order })
    this.syncOrder() if sync

  getInitialState: ->
    token: process.env.token
    domain: process.env.domain
    headers: {}
    cost:  []
    errors: []
    addressValidated: false

  componentWillMount: -> this.setState({ headers: { Authorization: "Bearer #{this.state.token}" } }) if this.state.token

  componentDidMount: ->
    react = this
    $.ajax
      url: 'http://staging.apeironsys.com/api/customers/info/'
      method: 'GET'
      headers: react.state.headers
      success: (rsp) ->
        react.setState({ email: rsp.email, name: rsp.customer_name, address: rsp.customer_service_address })

  render: ->
    <div id='app-component'>
      <HeaderComponent email={this.state.email} name={this.state.name} />
      <div id='container'>
        <nav>
          <div className='err'>0</div>
          <ul className='links'>
            <li><a href="javascript:void(0)" onClick={this.newOrder}>Start new order</a></li>
            <li><Link to="/list">List all customer orders</Link></li>
          </ul>
        </nav>
        <div id='content'>
          {this.props.children}
        </div>
      </div>
    </div>
