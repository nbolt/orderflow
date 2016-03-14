ListComponent = React.createClass
  componentDidMount: ->
    react = this
    $.ajax
      url: 'http://staging.apeironsys.com/api/customers/info/'
      method: 'GET'
      headers: { Authorization: 'Bearer ' + react.state.token }
      data: {  }
      dataType: 'json'
      success: (rsp) ->
        react.setState({ email: rsp.email, address: rsp.customer_service_address })

  getInitialState: ->
    token:   'rPjBmIkXis8TSVLrfLz16rYWK4Teszml2GvPjw5S41B9ZqPPk2ZcKDzFQWETXwrO'
    email:   null
    address: null

  render: ->
    <div id='order-list'>
    </div>
