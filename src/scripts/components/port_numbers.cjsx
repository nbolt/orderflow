PortNumbersComponent = React.createClass
  contextTypes:
    nav: React.PropTypes.func
    order: React.PropTypes.object
    updateOrder: React.PropTypes.func

  tab: (pane) -> this.setState({ tab: pane })

  backClass: ->
  continueClass: ->

  tabClass: (tab) ->
    react = this
    classNames 'tab',
      selected: tab == react.state.tab

  getInitialState: ->
    tab: 'port'

  render: ->
    <div id='port-numbers'>
      <div className='viewport'>
        <div className='tabs'>
          <div className={this.tabClass('port')} onClick={this.tab.bind(null, 'did')}>TFN & DID Port</div>
        </div>
      </div>
      <div className='foot'>
        <ul className='links'>
          <li className={this.backClass()}><a href='javascript:void(0)' onClick={this.context.nav.bind(null, 'back', this.props.route.path)}>Back</a></li>
          <li className={this.continueClass()}><a href='javascript:void(0)' onClick={this.context.nav.bind(null, 'continue', this.props.route.path)}>Continue</a></li>
        </ul>
      </div>
    </div>
