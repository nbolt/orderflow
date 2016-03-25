IPAddressesComponent = React.createClass
  contextTypes:
    nav: React.PropTypes.func
    order: React.PropTypes.object
    updateOrder: React.PropTypes.func
    removeArrayElement: React.PropTypes.func

  numIps: (dir) -> (_.get(this.context.order, "vs.#{dir}.trunk.entries.length") || 0) + 1

  updateIp: (i, dir, attr, ev) ->
    if _.isEmpty(ev.target.value)
      this.context.removeArrayElement([["vs.#{dir}.trunk.entries", i]]) if attr is 'ip'
    else
      this.context.updateOrder([["vs.#{dir}.trunk.entries[#{i}][#{attr}]", ev.target.value]])

  backClass: ->

  continueClass: -> 'hidden' if this.numIps() < 2

  ipClass: (dir) -> classNames 'direction',
    hidden: !_.get(this.context.order, "vs._service_direction[#{dir}]") && !_.get(this.context.order, "vs._service_direction.bi")

  render: ->
    react = this
    <div id='ip-addresses'>
      <div className='viewport'>
        <div className='ip-containers'>
          <div className='div'/>
          <div className={this.ipClass('out')}>
            <div className='columns'>
              <div className='column ip'>
                <div className='title'>IP Address</div>
                    {_.times(react.numIps('out'), (i) ->
                      <div className='field ip' id={"ip#{i}"} key={i}>
                        <input type='text' value={_.get(react.context.order, "vs.out.trunk.entries[#{i}].ip")} onChange={react.updateIp.bind(null, i, 'out', 'ip')}/>
                      </div>
                    )}
              </div>
              <div className='column'>
                <div className='title'>Mask</div>
                    {_.times(react.numIps('out'), (i) ->
                      <div className='field mask' id={"ip#{i}"} key={i}>
                        <input type='text' value={_.get(react.context.order, "vs.out.trunk.entries[#{i}].mask")} onChange={react.updateIp.bind(null, i, 'out', 'mask')}/>
                      </div>
                    )}
              </div>
              <div className='column'>
                <div className='title'>Port</div>
                    {_.times(react.numIps('out'), (i) ->
                      <div className='field port' id={"ip#{i}"} key={i}>
                        <input type='text' value={_.get(react.context.order, "vs.out.trunk.entries[#{i}].port")} onChange={react.updateIp.bind(null, i, 'out', 'port')}/>
                      </div>
                    )}
              </div>
            </div>
          </div>
          <div className={this.ipClass('in')}>
            <div className='columns'>
              <div className='column ip'>
                <div className='title'>IP Address</div>
                    {_.times(react.numIps('in'), (i) ->
                      <div className='field ip' id={"ip#{i}"} key={i}>
                        <input type='text' value={_.get(react.context.order, "vs.in.trunk.entries[#{i}].ip")} onChange={react.updateIp.bind(null, i, 'in', 'ip')}/>
                      </div>
                    )}
              </div>
              <div className='column'>
                <div className='title'>Mask</div>
                    {_.times(react.numIps('in'), (i) ->
                      <div className='field mask' id={"ip#{i}"} key={i}>
                        <input type='text' value={_.get(react.context.order, "vs.in.trunk.entries[#{i}].mask")} onChange={react.updateIp.bind(null, i, 'in', 'mask')}/>
                      </div>
                    )}
              </div>
              <div className='column'>
                <div className='title'>Port</div>
                    {_.times(react.numIps('in'), (i) ->
                      <div className='field port' id={"ip#{i}"} key={i}>
                        <input type='text' value={_.get(react.context.order, "vs.in.trunk.entries[#{i}].port")} onChange={react.updateIp.bind(null, i, 'in', 'port')}/>
                      </div>
                    )}
              </div>
              <div className='column'>
                <div className='title'>Weight</div>
                    {_.times(react.numIps('in'), (i) ->
                      <div className='field weight' id={"ip#{i}"} key={i}>
                        <input type='text' value={_.get(react.context.order, "vs.in.trunk.entries[#{i}].weight")} onChange={react.updateIp.bind(null, i, 'in', 'distro_percent')}/>
                      </div>
                    )}
              </div>
            </div>
          </div>
        </div>
      </div>
      <div className='foot'>
        <ul className='links'>
          <li className={this.backClass()}><a href='javascript:void(0)' onClick={this.context.nav.bind(null, 'back', this.props.route.path)}>Back</a></li>
          <li className={this.continueClass()}><a href='javascript:void(0)' onClick={this.context.nav.bind(null, 'continue', this.props.route.path)}>Continue</a></li>
        </ul>
      </div>
    </div>
