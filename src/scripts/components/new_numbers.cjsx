NewNumbersComponent = React.createClass
  contextTypes:
    token: React.PropTypes.string
    order: React.PropTypes.object
    updateOrder: React.PropTypes.func

  searchNumbers: (ev) ->
    react = this
    $.ajax
      url: 'http://staging.apeironsys.com/api/number_search'
      method: 'GET'
      headers: { Authorization: 'Bearer ' + react.context.token }
      dataType: 'json'
      data:
        list_id: react.context.order.id
        rate_center: 'ALBANY'
        state: 'NY'
      success: (rsp) ->
        console.log rsp

  componentDidMount: ->
    react = this
    window.wat = -> react.context.order

  render: ->
    <div id='new-numbers'>
      <input id='numbers' type='text' onChange={this.searchNumbers}/>
    </div>
