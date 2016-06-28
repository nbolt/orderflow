NumberFeaturesComponent = React.createClass
  contextTypes:
    nav: React.PropTypes.func
    order: React.PropTypes.object
    updateOrder: React.PropTypes.func

  toggle: (n, attr) ->
    switch n.action
      when 'new'
        all = _.get(this.context.order, 'vs.in.all')
        num = _.find(all, (num) -> n.number == num.number)
        if num[attr]
          num[attr] = false
        else
          num[attr] = true
        this.context.updateOrder([['vs.in.all', all]], true)
      when 'port'
        orders = _.get(this.context.order, 'vs.in.portorders')
        obj = null
        _.each(orders, (order) ->
          num = _.find(order.numbers, (num) -> num.number == n.number)
          obj = num if num
        )
        if obj[attr]
          obj[attr] = false
        else
          obj[attr] = true
        this.context.updateOrder([['vs.in.portorders', orders]], true)

  numbers: ->
    n = _.map(_.get(this.context.order, 'vs.in.all'), (n) -> n.action = 'new'; n)
    p = _.flatten _.map(_.get(this.context.order, 'vs.in.portorders'), (order) -> _.map(order.numbers, (n) -> n.action = 'port'; n.type = order.type; n))
    _.concat(n, p)

  attr: (n, attr) ->
    if attr == 'e911' && n.type == 'tfn'
      <div/>
    else
      if n[attr]
        <div className='check y' onClick={this.toggle.bind(null, n, attr)}>
          <div className='icon typcn typcn-media-record'/>
        </div>
      else
        <div className='check n' onClick={this.toggle.bind(null, n, attr)}>
          <div className='icon typcn typcn-media-record-outline'/>
        </div>

  attrInput: (n, attr, ev) ->
    switch n.action
      when 'new'
        all = _.get(this.context.order, 'vs.in.all')
        num = _.find(all, (num) -> n.number == num.number)
        num[attr] = ev.target.value
        this.context.updateOrder([['vs.in.all', all]], true)
      when 'port'
        orders = _.get(this.context.order, 'vs.in.portorders')
        obj = null
        _.each(orders, (order) ->
          num = _.find(order.numbers, (num) -> num.number == n.number)
          obj = num if num
        )
        obj[attr] = ev.target.value
        this.context.updateOrder([['vs.in.portorders', orders]], true)

  backClass: ->

  continueClass: ->

  render: ->
    react = this
    <div id='number-features'>
      <div className='viewport'>
        <div className='numbers-container'>
          <table>
            <thead>
              <tr>
                <th>Number</th>
                <th>Type</th>
                <th>Action</th>
                <th>E911</th>
                <th>Listing</th>
                <th>CNAM In</th>
                <th>CNAM Out</th>
                <th>SMS</th>
              </tr>
            </thead>
            <tbody>
              {_.map(this.numbers(), (n, i) ->
                <tr key={i}>
                  <td>{n.number}</td>
                  <td>{n.type.toUpperCase()}</td>
                  <td>{n.action.toUpperCase()}</td>
                  <td>{react.attr(n, 'e911')}</td>
                  <td><input type='text' value={n.name} onChange={react.attrInput.bind(null, n, 'name')}/></td>
                  <td>{react.attr(n, 'cnam')}</td>
                  <td><input type='text' value={n.cnam_out} onChange={react.attrInput.bind(null, n, 'cnam_out')}/></td>
                  <td>{react.attr(n, 'sms')}</td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </div>
      <div className='foot'>
        <ul className='links'>
          <li className={this.backClass()}><a href='javascript:void(0)' onClick={this.context.nav.bind(null, 'back', this.props.route.path)}>Back</a></li>
          <li className={this.continueClass()}><a href='javascript:void(0)' onClick={this.context.nav.bind(null, 'continue', this.props.route.path)}>Submit Numbers</a></li>
        </ul>
      </div>
    </div>
