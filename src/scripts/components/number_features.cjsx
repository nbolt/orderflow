NumberFeaturesComponent = React.createClass
  contextTypes:
    nav: React.PropTypes.func
    order: React.PropTypes.object
    updateOrder: React.PropTypes.func

  toggle: (n, attr) ->
    all = _.get(this.context.order, 'vs.in.all')
    num = _.find(all, (num) -> n.number == num.number)
    if num[attr]
      num[attr] = false
    else
      num[attr] = true
    this.context.updateOrder([['vs.in.all', all]], true)

  numbers: ->
    n = _.get(this.context.order, 'vs.in.all') || []
    p = _.get(this.context.order, 'vs.in.portorder.numbers') || []
    n = _.map(n, (n) -> n.action = 'new'; n)
    p = _.map(p, (n) -> n.action = 'port'; n)
    _.concat(n, p)

  attr: (n, attr) ->
    if n[attr]
      <div className='check y' onClick={this.toggle.bind(null, n, attr)}>
        <div className='icon typcn typcn-media-record'/>
      </div>
    else
      <div className='check n' onClick={this.toggle.bind(null, n, attr)}>
        <div className='icon typcn typcn-media-record-outline'/>
      </div>

  attrInput: (n, attr, ev) ->
    all = _.get(this.context.order, 'vs.in.all')
    num = _.find(all, (num) -> n.number == num.number)
    num[attr] = ev.target.value
    this.context.updateOrder([['vs.in.all', all]], true)

  backClass: ->

  continueClass: ->

  render: ->
    react = this
    <div id='number-features'>
      <div className='viewport'>
        <div className='numbers-container'>
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
          <div className='numbers'>
            {_.map(this.numbers(), (n, i) ->
              <div className='row number' key={i}>
                <div className='column'>
                  <div className='text'>{n.number}</div>
                </div>
                <div className='column'>
                  <div className='text'>{n.type.toUpperCase()}</div>
                </div>
                <div className='column'>
                  <div className='text'>{n.action.toUpperCase()}</div>
                </div>
                <div className='column'>
                  {react.attr(n, 'e911')}
                </div>
                <div className='column'>
                  <input type='text' value={n.name} onChange={react.attrInput.bind(null, n, 'name')}/>
                </div>
                <div className='column'>
                  {react.attr(n, 'cnam')}
                </div>
                <div className='column'>
                  <input type='text' value={n.cnam_out} onChange={react.attrInput.bind(null, n, 'cnam_out')}/>
                </div>
                <div className='column'>
                  {react.attr(n, 'sms')}
                </div>
              </div>
            )}
          </div>
        </div>
      </div>
      <div className='foot'>
        <ul className='links'>
          <li className={this.backClass()}><a href='javascript:void(0)' onClick={this.context.nav.bind(null, 'back', this.props.route.path)}>Back</a></li>
          <li className={this.continueClass()}><a href='javascript:void(0)' onClick={this.context.nav.bind(null, 'continue', this.props.route.path)}>Submit Numbers</a></li>
        </ul>
      </div>
    </div>
