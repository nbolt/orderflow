IPAddressesComponent = React.createClass
  contextTypes:
    nav: React.PropTypes.func
    order: React.PropTypes.object
    updateOrder: React.PropTypes.func
    removeArrayElement: React.PropTypes.func

  numIps: -> (_.get(this.context.order, 'vs.in.trunk.entries.length') || 0) + 1

  updateIp: (i, ev) ->
    if _.isEmpty(ev.target.value)
      this.context.removeArrayElement([["vs.in.trunk.entries", i]])
    else
      this.context.updateOrder([["vs.in.trunk.entries[#{i}].ip", ev.target.value]])

  backClass: ->

  continueClass: -> 'hidden' if this.numIps() < 2

  render: ->
    react = this
    <div id='ip-addresses'>
      <div className='viewport'>
        {_.times(react.numIps(), (i) ->
          <div className='ip' id={"ip#{i}"} key={i}>
            <input type='text' value={_.get(react.context.order, "vs.in.trunk.entries[#{i}].ip")} onChange={react.updateIp.bind(null, i)}/>
          </div>
        )}
      </div>
      <div className='foot'>
        <ul className='links'>
          <li className={this.backClass()}><a href='javascript:void(0)' onClick={this.context.nav.bind(null, 'back', this.props.route.path)}>Back</a></li>
          <li className={this.continueClass()}><a href='javascript:void(0)' onClick={this.context.nav.bind(null, 'continue', this.props.route.path)}>Continue</a></li>
        </ul>
      </div>
    </div>
