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

  render: ->
    <div id='number-features'>
      
    </div>
