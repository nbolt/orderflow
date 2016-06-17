ListComponent = React.createClass
  contextTypes:
    token: React.PropTypes.string
    domain: React.PropTypes.string
    headers: React.PropTypes.object

  nav: (ident) -> this.props.history.push("/order/#{ident}/service_type")

  created: (ts) -> moment(ts * 1000).format 'MM/DD/YY'

  type: (order) ->
    voice  = _.get(order, 'order.vs._enabled')
    sms    = _.get(order, 'order.sms._enabled')
    webrtc = _.get(order, 'order.webrtc._enabled')
    voice && 'voice' || sms && 'sms' || webrtc && 'webrtc'

  componentDidMount: ->
    react = this
    $.ajax
      url: "#{react.context.domain}/api/_flow/orders"
      method: 'GET'
      headers: react.context.headers
      data: {  }
      dataType: 'json'
      success: (rsp) ->
        react.setState({ orders: rsp })

  getInitialState: ->
    orders: []

  render: ->
    react = this
    <div id='order-list'>
      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>Started On</th>
            <th>Type</th>
            <th>Completed</th>
            <th>Options</th>
          </tr>
        </thead>
        <tbody>
          {_.map(this.state.orders, (o, i) ->
            <tr key={i}>
              <td>{o.ident}</td>
              <td>{react.created(o.created_ts)}</td>
              <td>{react.type(o)}</td>
              <td>{_.get(o, 'order.status')}</td>
              <td className='edit'><a className="edit" onClick={react.nav.bind(null, o.ident)}>Edit</a></td>
            </tr>
          )}
        </tbody>
      </table>
    </div>
