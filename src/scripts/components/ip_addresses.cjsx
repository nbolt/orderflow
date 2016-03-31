IPAddressesComponent = React.createClass
  contextTypes:
    nav: React.PropTypes.func
    order: React.PropTypes.object
    updateOrder: React.PropTypes.func
    removeArrayElement: React.PropTypes.func

  numIps: (dir) -> (_.get(this.context.order, "vs.#{dir}.trunk.entries.length") || 0) + 1

  selected: (path) ->
    classNames
      selected: _.get(this.context.order, path)

  updateIp: (i, dir, attr, ev) ->
    if _.isEmpty(ev.target.value)
      this.context.removeArrayElement([["vs.#{dir}.trunk.entries", i]]) if attr is 'ip'
    else
      this.context.updateOrder([["vs.#{dir}.trunk.entries[#{i}][#{attr}]", ev.target.value]])
    this.updateRouting()

  updateRouting: (type) ->
    react = this
    ips = this.numIps('in') - 1
    if type
      this.context.updateOrder([['vs.in.trunk.distro.type.hunt', type == 'hunt'], ['vs.in.trunk.distro.type.pd', type == 'pd'], ['vs.in.trunk.distro.type.rr', type == 'rr']], false)
    else
      hunt = _.get(this.context.order, 'vs.in.trunk.distro.type.hunt')
      pd   = _.get(this.context.order, 'vs.in.trunk.distro.type.pd')
      rr   = _.get(this.context.order, 'vs.in.trunk.distro.type.rr')
      type = hunt && 'hunt' || pd && 'pd' || rr && 'rr'
    switch type
      when 'hunt'
        _.times(ips, (i) ->
          n = 100; n = 0 unless i is 0
          react.context.updateOrder([["vs.in.trunk.entries[#{i}].distro_percent", n]], false)
        )
      when 'rr'
        _.times(ips, (i) ->
          react.context.updateOrder([["vs.in.trunk.entries[#{i}].distro_percent", (100 / ips).toFixed(0)]], false)
        )

  inboundCheck: (ev) -> this.context.updateOrder([['vs.in.trunk.inbound_checked', ev.target.checked]], false)

  backClass: ->

  continueClass: -> 'hidden' if this.numIps('out') < 2 || this.numIps('in') < 2 || (!_.get(this.context.order, 'vs.in.trunk.distro.type.hunt') && !_.get(this.context.order, 'vs.in.trunk.distro.type.pd') && !_.get(this.context.order, 'vs.in.trunk.distro.type.rr'))

  ipClass: (dir) -> classNames 'direction', dir,
    hidden: !_.get(this.context.order, "vs._service_direction[#{dir}]") && !_.get(this.context.order, "vs._service_direction.bi")

  weightInput: -> !_.get(this.context.order, 'vs.in.trunk.distro.type.pd')

  componentDidMount: ->
    this.updateRouting()

  render: ->
    react = this
    <div id='ip-addresses'>
      <div className='viewport'>
        <div className='ip-containers'>
          <div className='directions'>
            <div className='div'/>
            <div className={this.ipClass('out')}>
              <div className='title'>IP Addresses for Outbound</div>
              <div className='check'/>
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
              <div className='title'>IP Addresses for Outbound</div>
              <div className='check'>
                <label><input type='checkbox' checked={_.get(this.context.order, 'vs.in.trunk.inbound_checked')} onClick={this.inboundCheck} value={true}/>Check here if inbound ips are same as outbound</label>
              </div>
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
                          <input type='text' value={_.get(react.context.order, "vs.in.trunk.entries[#{i}].distro_percent")} onChange={react.updateIp.bind(null, i, 'in', 'distro_percent')} readOnly={react.weightInput()}/>
                        </div>
                      )}
                </div>
              </div>
            </div>
          </div>
        </div>
        <div className='routing-method'>
          <div className='title'>Inbound Routing Method:</div>
          <div className='options'>
            <div className={this.selected('vs.in.trunk.distro.type.hunt') + ' type'} onClick={this.updateRouting.bind(null, 'hunt')}>Hunt</div>
            <div className={this.selected('vs.in.trunk.distro.type.rr') + ' type'} onClick={this.updateRouting.bind(null, 'rr')}>Load Balanced</div>
            <div className={this.selected('vs.in.trunk.distro.type.pd') + ' type'} onClick={this.updateRouting.bind(null, 'pd')}>Weighted</div>
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
