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

  total: (type) -> _.reduce(this.context.cost, ((a, item) -> item["total_#{type}"] + a), 0)

  componentDidMount: ->
    this.context.syncOrder()

  render: ->
    <div id='review'>
      <div className='viewport'>
        <div className='costs'>
          <div className='totals'>
            <div className='total'>
              <div className='title'>Total NRC:</div>
              <div className='price'>{this.total('nrc')}</div>
            </div>
            <div className='total'>
              <div className='title'>Total MRC:</div>
              <div className='price'>{this.total('mrc')}</div>
            </div>
          </div>
          <div className='cost head'>
            <div className='column'>SKU</div>
            <div className='column'>Description</div>
            <div className='column'>Quantity</div>
            <div className='column'>Unit MRC</div>
            <div className='column'>Unit NRC</div>
            <div className='column'>Total MRC</div>
            <div className='column'>Total NRC</div>
          </div>
          {_.map(this.context.cost, (item, i) ->
            <div className='cost' key={i}>
              <div className='column'>{item['sku']}</div>
              <div className='column'>{item['description']}</div>
              <div className='column'>{item['quantity']}</div>
              <div className='column'>{item['unit_mrc']}</div>
              <div className='column'>{item['unit_nrc']}</div>
              <div className='column'>{item['total_mrc']}</div>
              <div className='column'>{item['total_nrc']}</div>
            </div>
          )}
        </div>
      </div>
      <div className='foot'>
        <ul className='links'>
          <li className={this.backClass()}><a href='javascript:void(0)' onClick={this.context.nav.bind(null, 'back', this.props.route.path)}>Back</a></li>
          <li className={this.continueClass()}><a href='javascript:void(0)' onClick={this.accept}>Accept Order</a></li>
        </ul>
      </div>
    </div>
