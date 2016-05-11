TrunkConfigComponent = React.createClass
  contextTypes:
    nav: React.PropTypes.func
    order: React.PropTypes.object
    updateOrder: React.PropTypes.func

  selected: (path) ->
    classNames
      selected: _.get(this.context.order, path)

  los_angeles: -> this.state.primary == 'los_angeles' && 'primary' || 'secondary'
  washington:  -> this.state.primary == 'washington'  && 'primary' || 'secondary'

  ip: (city) ->
    switch city
      when 'los_angeles' then '66.85.56.10/32'
      when 'washington'  then '66.85.57.10/32'

  options: -> [
    { value: 'primary', label: 'Primary' },
    { value: 'secondary', label: 'Secondary' }
  ]

  locChange: (city, data) ->
    if data
      other = city == 'los_angeles' && 'washington' || 'los_angeles'
      switch data.value
        when 'primary'
          this.setState({ primary: city, secondary: other })
          this.context.updateOrder([['vs.apeironIPprimary', {ip: this.ip(city), port: '5060'}], ['vs.apeironIPsecondary', {ip: this.ip(other), port: '5060'}]])
        when 'secondary'
          this.setState({ primary: other, secondary: city })
          this.context.updateOrder([['vs.apeironIPprimary', {ip: this.ip(other), port: '5060'}], ['vs.apeironIPsecondary', {ip: this.ip(city), port: '5060'}]])

  backClass: ->
  continueClass: ->

  getInitialState: ->
    primary: 'los_angeles'
    secondary: 'washington'

  render: ->
    <div id='trunk-config'>
      <div className='viewport'>
        <div className='section'>
          <div className='title'>Apeiron Equipment Interface Configuration</div>
          <div className='desc'>These are the IP addresses that you will use to send and receive SIP calls with Apeiron. We have completed a default configuration for you, please make any changes if necessary.</div>
          <div className='locations'>
            <div className='location'>
              <div className='ip-container'>
                <div className='ip'>66.85.56.10/32 - Port 5060</div>
                <div className='city'>Los Angeles, CA</div>
              </div>
              <div className='dropdown'>
                <Select value={this.los_angeles()} options={this.options()} onChange={this.locChange.bind(null, 'los_angeles')}/>
              </div>
            </div>
            <div className='location'>
              <div className='ip-container'>
                <div className='ip'>66.85.57.10/32 - Port 5060</div>
                <div className='city'>Washington, D.C.</div>
              </div>
              <div className='dropdown'>
                <Select value={this.washington()} options={this.options()} onChange={this.locChange.bind(null, 'washington')}/>
              </div>
            </div>
          </div>
        </div>
        <div className='section'>
          <div className='title'>Codec Configuration</div>
          <div className='options'>
            <div className='title'>Voice:</div>
            <div className={this.selected('vs.codec.rtp.G711u64K') + ' type'} onClick={this.context.updateOrder.bind(null, [['vs.codec.rtp.G711u64K', true]], false)}>G.711u 64K</div>
            <div className={this.selected('vs.codec.rtp.G729a') + ' type'} onClick={this.context.updateOrder.bind(null, [['vs.codec.rtp.G729a', true]], false)}>G.729a</div>
            <div className={this.selected('vs.codec.rtp.G722') + ' type'} onClick={this.context.updateOrder.bind(null, [['vs.codec.rtp.G722', true]], false)}>G.722</div>
          </div>
          <div className='options'>
            <div className='title'>DTMF:</div>
            <div className={this.selected('vs.codec.dtmf.RFC2833') + ' type'} onClick={this.context.updateOrder.bind(null, [['vs.codec.rtp.RFC2833', true]], false)}>RFC 2833</div>
            <div className={this.selected('vs.codec.dtmf.inband') + ' type'} onClick={this.context.updateOrder.bind(null, [['vs.codec.dtmf.inband', true]], false)}>Inband</div>
          </div>
          <div className='options'>
            <div className='title'>Fax:</div>
            <div className={this.selected('vs.codec.fax.T38Fallback') + ' type'} onClick={this.context.updateOrder.bind(null, [['vs.codec.fax.T38Fallback', true], ['vs.codec.fax.T38', false], ['vs.codec.fax.G711', false]], false)}>T.38 - G.711 Fallback</div>
            <div className={this.selected('vs.codec.fax.T38') + ' type'} onClick={this.context.updateOrder.bind(null, [['vs.codec.fax.T38Fallback', false], ['vs.codec.fax.T38', true], ['vs.codec.fax.G711', false]], false)}>T.38</div>
            <div className={this.selected('vs.codec.fax.G711') + ' type'} onClick={this.context.updateOrder.bind(null, [['vs.codec.fax.T38Fallback', false], ['vs.codec.fax.T38', false], ['vs.codec.fax.G711', true]], false)}>G.711 Passthrough</div>
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
