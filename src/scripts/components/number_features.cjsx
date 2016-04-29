NumberFeaturesComponent = React.createClass
  contextTypes:
    order: React.PropTypes.object
    updateOrder: React.PropTypes.func

  toggle: (type) ->
    order = this.context.order
    if !order.vs._enabled && !order.sms._enabled
      switch type
        when 'vs'  then this.context.updateOrder('vs._enabled', true)
        when 'sms' then this.context.updateOrder('sms._enabled', true)

  numbers: ->
    _.get(this.context.order, 'vs.in.all')

  render: ->
    react = this
    <div id='number-features'>
      <div className='numbers'>
        <div className='row head'>
          <div className='column'>
            <div className='text'>Number</div>
          </div>
          <div className='column'>
            <div className='text'>Type</div>
          </div>
          <div className='column'>
            <div className='text'>Action</div>
          </div>
          <div className='column'>
            <div className='text'>E911</div>
          </div>
          <div className='column'>
            <div className='text'>Listing</div>
          </div>
          <div className='column'>
            <div className='text'>CNAM In</div>
          </div>
          <div className='column'>
            <div className='text'>CNAM Out</div>
          </div>
          <div className='column'>
            <div className='text'>SMS</div>
          </div>
        </div>
        {_.map(this.numbers(), (n) ->
          <div className='row number'>
            <div className='column'>
              <div className='text'>{n.number}</div>
            </div>
            <div className='column'>
              <div className='text'>{n.type}</div>
            </div>
            <div className='column'>
              <div className='text'>{n.action}</div>
            </div>
            <div className='column'>
              {react.attr('e911')}
            </div>
            <div className='column'>
              <input type='text' value={n.name}/>
            </div>
            <div className='column'>
              {react.attr('cnam')}
            </div>
            <div className='column'>
              <input type='text' value={n.cnam_out}/>
            </div>
            <div className='column'>
              {react.attr('sms')}
            </div>
          </div>
        )}
      </div>
    </div>
