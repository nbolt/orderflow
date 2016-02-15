Link = ReactRouter.Link

ServiceTypeComponent = React.createClass
  contextTypes:
    order: React.PropTypes.object
    updateOrder: React.PropTypes.func

  toggle: (type) ->
    order = this.context.order
    this.context.updateOrder("vs._enabled", false)
    this.context.updateOrder("sms._enabled", false)
    this.context.updateOrder("#{type}._enabled", true)

  render: ->
    voice = classNames 'type',
      selected: this.context.order && this.context.order.vs._enabled
    sms   = classNames 'type',
      selected: this.context.order && this.context.order.sms._enabled

    <div id='service-type'>
      <div className='types'>
        <div className={voice} onClick={this.toggle.bind(null, 'vs')}>Voice</div>
        <div className={sms} onClick={this.toggle.bind(null, 'sms')}>SMS</div>
      </div>
    </div>