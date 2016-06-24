ServiceTypeComponent = React.createClass
  contextTypes:
    order: React.PropTypes.object
    errors: React.PropTypes.array
    errClass: React.PropTypes.func
    hintClass: React.PropTypes.func
    hintContent: React.PropTypes.func
    nav: React.PropTypes.func
    syncOrder: React.PropTypes.func
    updateOrder: React.PropTypes.func
    continueText: React.PropTypes.func

  updateInput: (path, ev) ->
    this.context.updateOrder([[path, parseInt(ev.target.value) || null]])

  hidden: (type) ->
    selected     = _.get(this.context.order, 'vs._enabled') || _.get(this.context.order, 'sms._enabled')
    selectedType = _.get(this.context.order, 'vs._enabled') && 'vs' || _.get(this.context.order, 'sms._enabled') && 'sms'
    classNames
      hidden: selected && selectedType != type

  selected: (path) ->
    classNames
      selected: _.get(this.context.order, path)

  backClass: ->

  continueClass: ->
    hidden = false

    hidden = true if !_.get(this.context, 'order.vs._enabled') && !_.get(this.context, 'order.sms._enabled')
    hidden = true if _.get(this.context, 'order.vs._enabled') && !_.get(this.context, 'order.vs._service_direction.in') && !_.get(this.context, 'order.vs._service_direction.out') && !_.get(this.context, 'order.vs._service_direction.bi')
    hidden = true if _.get(this.context, 'order.vs._enabled') && !_.get(this.context, 'order.vs.call_paths')
    hidden = true if _.get(this.context, 'order.vs._enabled') && (!_.get(this.context, 'order.vs._cpsin') || !_.get(this.context, 'order.vs._cpsout'))

    hidden = true if _.get(this.context, 'order.sms._enabled') && !_.get(this.context, 'order.sms._service_type.phone_number') && !_.get(this.context, 'order.sms._service_type.shortcode')
    hidden = true if _.get(this.context, 'order.sms._enabled') && (!_.get(this.context, 'order.sms._mpsin') || !_.get(this.context, 'order.sms._mpsout'))

    'hidden' if hidden

  render: ->
    <div id='service-type'>
      <div className='viewport'>
        <div className='options'>
          <div className={this.selected('vs._enabled') + this.hidden('vs') + ' type'} onClick={this.context.updateOrder.bind(null, [['vs._enabled', true], ['sms._enabled', false]], false)}>Voice</div>
          <div className={this.selected('sms._enabled') + this.hidden('sms') + ' type'} onClick={this.context.updateOrder.bind(null, [['vs._enabled', false], ['sms._enabled', true]], false)}>SMS</div>
          <div className={this.hidden('webrtc') + ' type'}>WebRTC</div>
        </div>
        <div className='type-containers'>
          <div className={this.selected('vs._enabled') + ' vs container'}>
            <div className='options'>
              <div className={this.selected('vs._service_direction.out') + ' type'} onClick={this.context.updateOrder.bind(null, [['vs._service_direction.out', true], ['vs._service_direction.in', false], ['vs._service_direction.bi', false]], false)}>Oubound</div>
              <div className={this.selected('vs._service_direction.in') + ' type'} onClick={this.context.updateOrder.bind(null, [['vs._service_direction.out', false], ['vs._service_direction.in', true], ['vs._service_direction.bi', false]], false)}>Inbound</div>
              <div className={this.selected('vs._service_direction.bi') + ' type'} onClick={this.context.updateOrder.bind(null, [['vs._service_direction.out', false], ['vs._service_direction.in', false], ['vs._service_direction.bi', true]], false)}>Bidirectional</div>
            </div>
            <div className='call_paths'>
              <div className={'field ' + this.context.hintClass('vs.call_paths')} aria-label={this.context.hintContent('vs.call_paths')}>
                <label>Call Paths</label>
                <input className={this.context.errClass('vs.call_paths')} value={_.get(this.context, 'order.vs.call_paths')} onChange={this.updateInput.bind(null, 'vs.call_paths')} type='text'/>
              </div>
            </div>
            <div className='call_rates'>
              <div className={'field ' + this.context.hintClass('vs._cpsin')} aria-label={this.context.hintContent('vs._cpsin')}>
                <label>Calls / second (CPS) IN</label>
                <input className={this.context.errClass('vs._cpsin')} value={_.get(this.context, 'order.vs._cpsin')} onChange={this.updateInput.bind(null, 'vs._cpsin')} type='text'/>
              </div>
              <div className={'field ' + this.context.hintClass('vs._cpsout')} aria-label={this.context.hintContent('vs._cpsout')}>
                <label>Calls / second (CPS) OUT</label>
                <input className={this.context.errClass('vs._cpsout')} value={_.get(this.context, 'order.vs._cpsout')} onChange={this.updateInput.bind(null, 'vs._cpsout')} type='text'/>
              </div>
            </div>
          </div>
          <div className={this.selected('sms._enabled') + ' sms container'}>
            <div className='options'>
              <div className={this.selected('sms._service_type.phone_number') + ' type'} onClick={this.context.updateOrder.bind(null, [['sms._service_type.phone_number', true], ['sms._service_type.shortcode', false]])}>Phone Number</div>
              <div className={this.selected('sms._service_type.shortcode') + ' type'} onClick={this.context.updateOrder.bind(null, [['sms._service_type.phone_number', false], ['sms._service_type.shortcode', true]])}>Shortcode</div>
            </div>
            <div className='message-volume'>
              <div className='field'>
                <label>Messages / second (MPS) IN</label>
                <input value={_.get(this.context, 'order.sms._mpsin')} onChange={this.updateInput.bind(null, 'sms._mpsin')} type='text'/>
              </div>
              <div className='field'>
                <label>Messages / second (MPS) OUT</label>
                <input value={_.get(this.context, 'order.sms._mpsout')} onChange={this.updateInput.bind(null, 'sms._mpsout')} type='text'/>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div className='foot'>
        <ul className='links'>
          <li className={this.backClass()}><a href='javascript:void(0)' onClick={this.context.nav.bind(null, 'back', this.props.route.path)}>Back</a></li>
          <li className={this.continueClass()}><a href='javascript:void(0)' onClick={this.context.nav.bind(null, 'continue', this.props.route.path)}>{this.context.continueText('service_type')}</a></li>
        </ul>
      </div>
    </div>
