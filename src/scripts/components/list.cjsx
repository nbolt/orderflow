ListComponent = React.createClass
  componentDidMount: ->
    react = this
    $.ajax
      url: 'http://staging.apeironsys.com/api/_flow/orders'
      method: 'GET'
      headers: { Authorization: 'Bearer ' + react.state.token }
      data: {  }
      dataType: 'json'
      success: (rsp) ->
        react.setState({ orders: rsp })

  getInitialState: ->
    token:   'rPjBmIkXis8TSVLrfLz16rYWK4Teszml2GvPjw5S41B9ZqPPk2ZcKDzFQWETXwrO'
    email:   null
    address: null

  render: ->
    <div id='order-list'>
        {react.props.rsp.children}
    </div>
