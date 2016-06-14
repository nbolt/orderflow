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
      if attr == 'ip'
        this.context.removeArrayElement([["vs.#{dir}.trunk.entries", i]])
        if dir == 'out' && _.get(this.context.order, 'vs.in.trunk.inbound_checked')
          this.context.removeArrayElement([["vs.in.trunk.entries", i]])
      else
        this.context.updateOrder([["vs.#{dir}.trunk.entries[#{i}][#{attr}]", '']])
    else
      value = ev.target.value
      value = parseInt value if attr != 'ip'
      updatePort = attr != 'port' && $("##{dir}-port-#{i} input").val() != '' && !_.get(this.context.order, "vs.#{dir}.trunk.entries[#{i}].port")
      portValue  = $("##{dir}-port-#{i} input").val()
      this.context.updateOrder([["vs.#{dir}.trunk.entries[#{i}][#{attr}]", value]])
      if dir == 'out' && _.get(this.context.order, 'vs.in.trunk.inbound_checked')
        this.context.updateOrder([["vs.in.trunk.entries[#{i}][#{attr}]", value]])
        this.context.updateOrder([["vs.in.trunk.entries[#{i}].port", portValue]]) if updatePort
      this.context.updateOrder([["vs.#{dir}.trunk.entries[#{i}].port", portValue]]) if updatePort
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
        num = parseInt (100 / ips).toFixed(0)
        _.times(ips, (i) ->
          react.context.updateOrder([["vs.in.trunk.entries[#{i}].distro_percent", num]], false)
        )
        total = 0
        _.times(ips, (i) ->
          total += _.get(react.context.order, "vs.in.trunk.entries[#{i}].distro_percent")
        )
        react.context.updateOrder([["vs.in.trunk.entries[0].distro_percent", num + (100 - total)]], false)

  inboundCheck: (ev) ->
    react = this
    this.context.updateOrder([['vs.in.trunk.inbound_checked', ev.target.checked]], false)
    if ev.target.checked
      this.context.updateOrder([["vs.in.trunk.entries", []]], false)
      _.times(this.numIps('out') - 1, (i) ->
        ip   = _.get(react.context.order, "vs.out.trunk.entries[#{i}].ip")
        mask = _.get(react.context.order, "vs.out.trunk.entries[#{i}].mask")
        port = _.get(react.context.order, "vs.out.trunk.entries[#{i}].port")
        react.context.updateOrder([["vs.in.trunk.entries[#{i}].ip", ip], ["vs.in.trunk.entries[#{i}].mask", mask], ["vs.in.trunk.entries[#{i}].port", port]], false)
      )
      this.updateRouting()

  backClass: ->

  continueClass: -> 'hidden' if !this.validateFields() || ((_.get(this.context.order, "vs._service_direction.bi") || _.get(this.context.order, "vs._service_direction.out")) && this.numIps('out') < 2) || ((_.get(this.context.order, "vs._service_direction.bi") || _.get(this.context.order, "vs._service_direction.in")) && (this.numIps('in') < 2 || (!_.get(this.context.order, 'vs.in.trunk.distro.type.hunt') && !_.get(this.context.order, 'vs.in.trunk.distro.type.pd') && !_.get(this.context.order, 'vs.in.trunk.distro.type.rr'))))

  ipClass: (dir) -> classNames 'direction', dir,
    hidden: !_.get(this.context.order, "vs._service_direction[#{dir}]") && !_.get(this.context.order, "vs._service_direction.bi")

  validateFields: ->
    react = this
    validated = true
    _.each(['out', 'in'], (dir) ->
      _.each(['ip', 'mask', 'port', 'weight'], (field) ->
        _.times(react.numIps(dir) - 1, (i) ->
          validated = false unless react.validateField(field, dir, i)
        )
      )
    )
    validated

  validateField: (field, dir, i) ->
    react = this
    switch field
      when 'ip'
        ip = _.get(this.context.order, "vs.#{dir}.trunk.entries[#{i}].ip")
        nums = _.map(_.split(ip, '.'), (str) -> parseInt str)
        nums[0] > 0 && nums[0] < 256 && nums[1] >= 0 && nums[1] < 256 && nums[2] >= 0 && nums[2] < 256 && nums[3] >= 0 && nums[3] < 256
      when 'mask'
        mask = _.get(this.context.order, "vs.#{dir}.trunk.entries[#{i}].mask")
        mask == 24 || mask == 25 || mask == 26 || mask == 27 || mask == 28 || mask == 29 || mask == 30 || mask == 32
      when 'port'
        port = _.get(this.context.order, "vs.#{dir}.trunk.entries[#{i}].port")
        port >= 2500 && port <= 65555
      when 'weight'
        return true if dir == 'out'
        if _.get(this.context.order, 'vs.in.trunk.distro.type.pd')
          sum = 0
          _.times(this.numIps(dir) - 1, (i) ->
            weight = _.get(react.context.order, "vs.#{dir}.trunk.entries[#{i}].distro_percent")
            sum += weight
          )
          sum == 100
        else
          true

  fieldClass: (field, dir, i) ->
    react = this
    classNames
      invalid: !react.validateField(field, dir, i) && i != (react.numIps(dir)-1)

  routingClass: (field, dir, i) ->
    react = this
    classNames 'routing-method',
      hidden: _.get(react.context.order, 'vs._service_direction.out')

  weightInput: -> !_.get(this.context.order, 'vs.in.trunk.distro.type.pd')

  masks: -> [
    { value: 24, label: '24' },
    { value: 25, label: '25' },
    { value: 26, label: '26' },
    { value: 27, label: '27' },
    { value: 28, label: '28' },
    { value: 29, label: '29' },
    { value: 30, label: '30' },
    { value: 32, label: '32' },
  ]

  maskChange: (i, dir, attr, data) ->
    if data
      this.context.updateOrder([["vs.#{dir}.trunk.entries[#{i}][#{attr}]", data.value]]) unless dir == 'in' && _.get(this.context.order, 'vs.in.trunk.inbound_checked')
      if dir == 'out' && _.get(this.context.order, 'vs.in.trunk.inbound_checked')
        this.context.updateOrder([["vs.in.trunk.entries[#{i}][#{attr}]", data.value]])
    else
      this.context.updateOrder([["vs.#{dir}.trunk.entries[#{i}][#{attr}]", null]])
      if dir == 'out' && _.get(this.context.order, 'vs.in.trunk.inbound_checked')
        this.context.updateOrder([["vs.in.trunk.entries[#{i}][#{attr}]", null]])
    this.updateRouting()

  render: ->
    react = this
    <div id='ip-addresses'>
      <div className='viewport'>
        <div className='ip-containers'>
          <div className='directions'>
            <div className={'_' + this.ipClass('out') + ' div'}/>
            <div className={this.ipClass('out')}>
              <div className='title'>IP Addresses for Outbound</div>
              <div className='check'/>
              <div className='columns'>
                <div className='column ip'>
                  <div className='title'>IP Address</div>
                      {_.times(react.numIps('out'), (i) ->
                        <div className='field ip' id={"out-ip-#{i}"} key={i}>
                          <input type='text' className={react.fieldClass('ip', 'out', i)} value={_.get(react.context.order, "vs.out.trunk.entries[#{i}].ip")} onChange={react.updateIp.bind(null, i, 'out', 'ip')}/>
                        </div>
                      )}
                </div>
                <div className='column'>
                  <div className='title'>Mask</div>
                      {_.times(react.numIps('out'), (i) ->
                        <div className='field mask' id={"out-mask-#{i}"} key={i}>
                          <Select value={_.get(react.context.order, "vs.out.trunk.entries[#{i}].mask")} options={react.masks()} onChange={react.maskChange.bind(null, i, 'out', 'mask')}/>
                        </div>
                      )}
                </div>
                <div className='column'>
                  <div className='title'>Port</div>
                      {_.times(react.numIps('out'), (i) ->
                        <div className='field port' id={"out-port-#{i}"} key={i}>
                          <input type='text' defaultValue={5060} placeholder='5060' className={react.fieldClass('port', 'out', i)} value={_.get(react.context.order, "vs.out.trunk.entries[#{i}].port")} onChange={react.updateIp.bind(null, i, 'out', 'port')}/>
                        </div>
                      )}
                </div>
              </div>
            </div>
            <div className={this.ipClass('in')}>
              <div className='title'>IP Addresses for Inbound</div>
              <div className={'_' + this.ipClass('out') + ' check'}>
                <label><input type='checkbox' checked={_.get(this.context.order, 'vs.in.trunk.inbound_checked')} onChange={this.inboundCheck} value={true}/>Check here if inbound ips are same as outbound</label>
              </div>
              <div className='columns'>
                <div className='column ip'>
                  <div className='title'>IP Address</div>
                      {_.times(react.numIps('in'), (i) ->
                        <div className='field ip' id={"in-ip-#{i}"} key={i}>
                          <input type='text' readOnly={_.get(react.context.order, 'vs.in.trunk.inbound_checked')} className={react.fieldClass('ip', 'in', i)} value={_.get(react.context.order, "vs.in.trunk.entries[#{i}].ip")} onChange={react.updateIp.bind(null, i, 'in', 'ip')}/>
                        </div>
                      )}
                </div>
                <div className='column'>
                  <div className='title'>Mask</div>
                      {_.times(react.numIps('in'), (i) ->
                        <div className='field mask' id={"in-mask-#{i}"} key={i}>
                          <Select readOnly={_.get(react.context.order, 'vs.in.trunk.inbound_checked')} value={_.get(react.context.order, "vs.in.trunk.entries[#{i}].mask")} options={react.masks()} onChange={react.maskChange.bind(null, i, 'in', 'mask')}/>
                        </div>
                      )}
                </div>
                <div className='column'>
                  <div className='title'>Port</div>
                      {_.times(react.numIps('in'), (i) ->
                        <div className='field port' id={"in-port-#{i}"} key={i}>
                          <input type='text' defaultValue={5060} readOnly={_.get(react.context.order, 'vs.in.trunk.inbound_checked')} placeholder='5060' className={react.fieldClass('port', 'in', i)} value={_.get(react.context.order, "vs.in.trunk.entries[#{i}].port")} onChange={react.updateIp.bind(null, i, 'in', 'port')}/>
                        </div>
                      )}
                </div>
                <div className='column'>
                  <div className='title'>Weight</div>
                      {_.times(react.numIps('in'), (i) ->
                        <div className='field weight' id={"in-weight-#{i}"} key={i}>
                          <input type='text' className={react.fieldClass('weight', 'in', i)} value={_.get(react.context.order, "vs.in.trunk.entries[#{i}].distro_percent")} onChange={react.updateIp.bind(null, i, 'in', 'distro_percent')} readOnly={react.weightInput()}/>
                        </div>
                      )}
                </div>
              </div>
            </div>
          </div>
        </div>
        <div className={this.routingClass()}>
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
