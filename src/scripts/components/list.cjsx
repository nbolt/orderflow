ListComponent = React.createClass
  contextTypes:
    token: React.PropTypes.string

  nav: (ident) ->
    this.props.history.push("/order/#{ident}")

  componentDidMount: ->
    react = this
    $.ajax
      url: 'http://staging.apeironsys.com/api/_flow/orders'
      method: 'GET'
      headers: { Authorization: 'Bearer ' + react.context.token }
      data: {  }
      dataType: 'json'
      success: (rsp) ->
        react.setState({ orders: rsp })

  getInitialState: ->
    orders: []

  render: ->
    react = this
    <div id='order-list'>
        {_.map(this.state.orders, (order, i) ->
          <div className='order' key={i} onClick={react.nav.bind(null, order.ident)}>{order.ident}</div>
        )}
    </div>
