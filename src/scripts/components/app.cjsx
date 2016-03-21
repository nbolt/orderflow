Link = ReactRouter.Link

AppComponent = React.createClass
  childContextTypes:
    token: React.PropTypes.string
    address: React.PropTypes.object
    order: React.PropTypes.object
    fetchOrder: React.PropTypes.func
    updateOrder: React.PropTypes.func
    removeArrayElement: React.PropTypes.func
    syncOrder: React.PropTypes.func

  getChildContext: ->
    token: this.state.token
    address: this.state.address
    order: this.state.order || {}
    fetchOrder: this.fetchOrder
    updateOrder: this.updateOrder
    removeArrayElement: this.removeArrayElement
    syncOrder: this.syncOrder

  getInitialState: ->
    token:   'Bv020OGGCrw4eudKQn2Usyl8vSu4WyBY9XxTBxgqCtbfwoxCnkPL5YMLWSJyiBQB'

  newOrder: ->
    react = this
    $.ajax
      url: 'http://staging.apeironsys.com/api/_flow/orders'
      method: 'POST'
      headers: { Authorization: 'Bearer ' + react.state.token }
      dataType: 'json'
      success: (rsp) ->
        react.props.history.push("/order/#{rsp.ident}/service_type")
        react.fetchOrder()

  fetchOrder: ->
    react = this
    $.ajax
      url: "http://staging.apeironsys.com/api/_flow/orders/#{react.props.params.ident}"
      method: 'GET'
      headers: { Authorization: 'Bearer ' + react.state.token }
      dataType: 'json'
      success: (rsp) ->
        react.setState({ order: rsp.order })

  syncOrder: ->
    react = this
    $.ajax
      url: "http://staging.apeironsys.com/api/_flow/orders/#{react.props.params.ident}"
      method: 'PUT'
      headers: { Authorization: 'Bearer ' + react.state.token }
      dataType: 'json'
      contentType: 'application/json'
      data: JSON.stringify({ order: react.state.order })

  updateOrder: (values, sync=false) ->
    order = this.state.order || {vs:{_enabled:false,call_paths:100,_cpsin:20,_cpsout:20,in:{all:[],trunk:{entries:[]}}},sms:{_enabled:false,_mpsin:1,_mpsout:1}}
    _.each(values, (v) -> _.set(order, v[0], v[1]))
    this.setState({ order: order })
    this.syncOrder() if sync

  removeArrayElement: (values, sync=false) ->
    order = this.state.order
    _.each(values, (v) -> _.remove(_.get(order, v[0]), (e,i) -> v[1] == i))
    this.setState({ order: order })
    this.syncOrder() if sync

  componentDidMount: ->
    react = this
    $.ajax
      url: 'http://staging.apeironsys.com/api/customers/info/'
      method: 'GET'
      headers: { Authorization: 'Bearer ' + react.state.token }
      success: (rsp) ->
        react.setState({ email: rsp.email, name: rsp.customer_name, address: rsp.customer_service_address })

  render: ->
    <div id='app-component'>
      <HeaderComponent email={this.state.email} name={this.state.name} />
      <div id='container'>
        <nav>
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
