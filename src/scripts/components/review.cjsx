ReviewComponent = React.createClass
  contextTypes:
    home: React.PropTypes.func
    nav: React.PropTypes.func
    cost: React.PropTypes.array
    order: React.PropTypes.object
    syncOrder: React.PropTypes.func
    updateOrder: React.PropTypes.func

  accept: ->
    this.context.updateOrder([['status', 'Completed']], true)
    this.context.home()

  backClass: ->
  continueClass: ->

  componentDidMount: ->
    this.context.syncOrder()

  render: ->
    <div id='review'>
      <div className='viewport'>
        <div className='costs'>
          <table>
            <thead>
              <tr>
                <th>SKU</th>
                <th>Description</th>
                <th>Quantity</th>
                <th>Unit NRC</th>
                <th>Unit MRC</th>
                <th>Total NRC</th>
                <th>Total MRC</th>
              </tr>
            </thead>
            <tbody>
              {_.map(this.context.cost, (item, i) ->
                <tr key={i}>
                  <td>{item['sku']}</td>
                  <td>{item['description']}</td>
                  <td>{item['quantity']}</td>
                  <td>{item['unit_nrc']}</td>
                  <td>{item['unit_mrc']}</td>
                  <td>{item['total_nrc']}</td>
                  <td>{item['total_mrc']}</td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </div>
      <div className='foot'>
        <ul className='links'>
          <li className={this.backClass()}><a href='javascript:void(0)' onClick={this.context.nav.bind(null, 'back', this.props.route.path)}>Back</a></li>
          <li className={this.continueClass()}><a href='javascript:void(0)' onClick={this.accept}>Accept Order</a></li>
        </ul>
      </div>
    </div>
