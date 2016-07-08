Modal = ReactModal

PortNumbersComponent = React.createClass
  contextTypes:
    token: React.PropTypes.string
    domain: React.PropTypes.string
    headers: React.PropTypes.object
    nav: React.PropTypes.func
    order: React.PropTypes.object
    updateOrder: React.PropTypes.func
    removeArrayElement: React.PropTypes.func
    continueText: React.PropTypes.func

  invoice: -> $('#upload').click()

  upload: ->
    react = this
    data = new FormData()
    data.append('file', $('#upload').get(0).files[0]);
    $.ajax
      url: "#{react.context.domain}/api/files/upload/"
      method: 'POST'
      headers: react.context.headers
      dataType: 'json'
      contentType: false
      processData: false
      cache: false
      data: data
      success: (rsp) ->
        order = react.state.order
        order.invoices.push({ id: rsp[0]['id'], filename: rsp[0]['filename'] })
        react.setState({ order: order })
        $('#upload').val('')

  numberInfo: (n) ->
    react = this
    api =
      switch this.state.order.type
        when 'did' then "/api/phonenumber/#{n}/info"
        when 'tfn' then "/api/lnp/#{n}"
    $.ajax
      url: "#{react.context.domain}#{api}"
      method: 'GET'
      headers: react.context.headers
      dataType: 'json'
      success: (rsp) ->
        numbers = react.state.numbers
        numbers[n] = if react.state.order.type == 'did' then rsp else { portable: rsp.can_port }
        react.setState({ numbers: numbers })

  edit: (i) ->
    order = _.get(this.context.order, "vs.in.portorders[#{i}]")
    this.setState({ order: order, editing: i, raw_numbers: _.map(order.numbers, (n) -> n.number).join("\n") })

  remove: ->
    this.context.removeArrayElement([["vs.in.portorders", this.state.editing]], true)
    this.close()

  removeNumber: (number) ->
    react = this
    _.each(this.context.order.vs.in.portorders, (order, i) ->
      if _.find(order.numbers, (n) -> n.number == number)
        nums = _.filter(order.numbers, (n) -> n.number != number)
        react.setState({ raw_numbers: nums.join("\n") })
        react.context.updateOrder([["vs.in.portorders[#{i}].numbers", nums]], true)
    )

  removeInvoice: (id) ->
    react = this
    _.each(this.context.order.vs.in.portorders, (order, i) ->
      react.context.updateOrder([["vs.in.portorders[#{i}].invoices", _.filter(order.invoices, (invoice) -> invoice.id != id)]], true)
    )

  updateField: (field, ev) ->
    order = this.state.order
    order[field] = ev.target.value
    this.setState({ order: order })

  updateOrder: (key, value) ->
    order = this.state.order
    order[key] = value
    this.setState({ order: order })

  rawNums: -> this.state.raw_numbers && this.state.raw_numbers.split("\n")

  updateRawNumbers: (ev) -> this.setState({ raw_numbers: ev.target.value })

  close: -> this.setState({ order: {numbers:[],invoices:[]}, raw_numbers: '', editing: false, modal: false, numbers: {} })

  submit: ->
    react = this
    nums = _.reject(this.state.raw_numbers.split("\n"), (str) -> _.isEmpty(str) || react.portText(str) == 'Not Portable')
    this.state.order.numbers = _.map(nums, (n) -> { number: n.replace(/\D/g, '') })
    i = if _.isInteger(this.state.editing) then this.state.editing else this.context.order.vs.in.portorders.length
    this.context.updateOrder([["vs.in.portorders[#{i}]", this.state.order]], true)
    this.close()

  submitModal: (i, nums) ->
    react = this
    this.setState({ modal: !this.state.modal })
    this.edit i if _.isInteger i
    if nums
      this.setState({ raw_numbers: this.state.raw_numbers.replace(/\n$/, '') }) unless _.isEmpty(this.state.raw_numbers)
      _.each(this.rawNums(), (n) ->
        react.numberInfo n
      )

  selected: (key, value) ->
    react = this
    classNames
      selected: react.state.order[key] == value

  tab: (pane) -> this.setState({ tab: pane })

  backClass: ->
  continueClass: ->

  tabClass: (tab) ->
    react = this
    classNames 'tab',
      selected: tab == react.state.tab

  paneClass: (pane) ->
    react = this
    classNames 'tab-pane', pane,
      hidden: !react.state.tab || react.state.tab != pane

  oType: ->
    type = _.get(this.state.order, 'type')
    type == 'tfn' && 'Toll Free' || type == 'did' && 'DID'

  oPort: ->
    full = _.get(this.state.order, 'full')
    full && 'Full' || 'Partial'

  oInvoices: ->
    _.map(_.get(this.state.order, 'invoices'), (i) -> i.filename).join(', ')

  oInvoices: ->
    react = this
    _.map(this.state.order.invoices, (i) ->
      <div key={i.id} onClick={react.removeInvoice.bind(null, i.id)}>{i.filename}</div>
    )

  oNums: ->
    react = this
    _.map(this.rawNums(), (n, i) ->
      switch react.state.order.type
        when 'tfn'
          <tr key={i}>
            <td>{n}</td>
            <td className={react.numClass(n)}>{react.portText(n)}</td>
          </tr>
        when 'did'
          <tr key={i}>
            <td>{n}</td>
            <td className={react.numClass(n)}>{react.portText(n)}</td>
            <td>{_.get(react.state.numbers[n], 'state')}</td>
            <td>{_.get(react.state.numbers[n], 'rate_center')}</td>
            <td>{_.get(react.state.numbers[n], 'lata')}</td>
            <td>{_.get(react.state.numbers[n], 'ocn')}</td>
            <td>{_.get(react.state.numbers[n], 'ocn_name')}</td>
          </tr>
    )

  portText: (num) ->
    if _.isInteger(this.state.editing) && _.find(this.state.order.numbers, (n) -> n.number == num)
      'Portable'
    else
      _.get(this.state.numbers[num], 'portable') && 'Portable' || 'Not Portable'

  numClass: (n) ->
    classNames 'status',
      err: this.portText(n) == 'Not Portable'

  toggleModal: ->
    this.setState({ modal: !this.state.modal })

  modalNav: ->
    if _.isInteger this.state.editing
      <div className='actions'>
        <div className='action' onClick={this.close}>Close</div>
        <div className='action' onClick={this.submitModal}>Edit</div>
        <div className='action' onClick={this.remove}>Remove</div>
        <div className='action' onClick={this.submit}>Submit</div>
      </div>
    else
      <div className='actions'>
        <div className='action' onClick={this.submitModal}>Close</div>
        <div className='action' onClick={this.submit}>Submit Numbers to Order</div>
      </div>

  getInitialState: ->
    tab: 'port'
    order: {numbers: [], invoices: []}
    editing: false
    modal: false
    numbers: {}

  render: ->
    react = this
    <div id='port-numbers'>
      <Modal className='port-numbers' isOpen={this.state.modal}>
        <h1>Order Details</h1>
        <div className='fields'>
          <div className='field third'>
            <div className='label'>Type:</div>
            <div className='value'>{this.oType()}</div>
          </div>
          <div className='field third'>
            <div className='label'>Billing #:</div>
            <div className='value'>{_.get(this.state.order, 'btn')}</div>
          </div>
          <div className='field third'>
            <div className='label'>Port:</div>
            <div className='value'>{this.oPort()}</div>
          </div>
          <div className='field third'>
            <div className='label'>Provider:</div>
            <div className='value'>{_.get(this.state.order, 'provider')}</div>
          </div>
          <div className='field third'>
            <div className='label'>PIN:</div>
            <div className='value'>{_.get(this.state.order, 'pin')}</div>
          </div>
          <div className='field third'>
            <div className='label'>Auth Name:</div>
            <div className='value'>{_.get(this.state.order, 'name')}</div>
          </div>
          <div className='field half'>
            <div className='label'>Address:</div>
            <div className='value'>{_.get(this.state.order, 'address')}</div>
          </div>
          <div className='field half'>
            <div className='label'>Invoices:</div>
            <div className='value'>{this.oInvoices()}</div>
          </div>
          <div className='field table'>
            <table>
              <thead>
                  {(->
                    switch react.state.order.type
                      when 'tfn'
                        <tr>
                          <th>Number</th>
                          <th>Status</th>
                        </tr>
                      when 'did'
                        <tr>
                          <th>Number</th>
                          <th>Status</th>
                          <th>State</th>
                          <th>Rate Center</th>
                          <th>LATA</th>
                          <th>Original OCN</th>
                          <th>Original OCN Name</th>
                        </tr>
                   )()}
              </thead>
              <tbody>
                {this.oNums()}
              </tbody>
            </table>
            <div className='msg'>non-portable numbers will not be added</div>
          </div>
        </div>
        {this.modalNav()}
      </Modal>
      <div className='viewport'>
        <div className='tabs'>
          <div className={this.tabClass('port')} onClick={this.tab.bind(null, 'did')}>TFN & DID Port</div>
        </div>
        <div className='tab-content'>
          <div className={this.paneClass('port')}>
            <div className='column entry'>
              <div className='title'>Number Entry</div>
              <div className='content'>
                <div className='options'>
                  <div className='title'>Type:</div>
                  <div className={this.selected('type', 'tfn') + ' type'} onClick={this.updateOrder.bind(null, 'type', 'tfn')}>Toll Free</div>
                  <div className={this.selected('type', 'did') + ' type'} onClick={this.updateOrder.bind(null, 'type', 'did')}>DID</div>
                </div>
                <div className='options'>
                  <div className='title'>Billing Number:</div>
                  <input type='text' value={this.state.order.btn} onChange={this.updateField.bind(null, 'btn')}/>
                </div>
                <div className='options'>
                  <div className='title'>Full / Partial Port:</div>
                  <div className={this.selected('full', true) + ' type'} onClick={this.updateOrder.bind(null, 'full', true)}>Full</div>
                  <div className={this.selected('full', false) + ' type'} onClick={this.updateOrder.bind(null, 'full', false)}>Partial</div>
                </div>
              </div>
              <div className='input'>
                <textarea value={this.state.raw_numbers} onChange={this.updateRawNumbers} rows='6' placeholder='Input number list, one per line.'></textarea>
                <div className='msg'>one number per line</div>
              </div>
              <div className='provider-info'>
                <input type='text' placeholder='Current Provider' value={this.state.order.provider} onChange={this.updateField.bind(null, 'provider')}/>
                <input type='text' placeholder='Authorization Name' value={this.state.order.name} onChange={this.updateField.bind(null, 'name')}/>
                <input type='text' placeholder='Provider Address' value={this.state.order.address} onChange={this.updateField.bind(null, 'address')}/>
                <input type='text' placeholder='PIN Number (if known)' value={this.state.order.pin} onChange={this.updateField.bind(null, 'pin')}/>
              </div>
              <div className='submit'>
                <div className='links'>
                  <div className='link' onClick={this.invoice}>Upload Invoice</div>
                  <div className='link' onClick={this.submitModal.bind(null, null, true)}>Submit Numbers to Order</div>
                </div>
                <input id='upload' type='file' onChange={this.upload}/>
              </div>
            </div>
            <div className='column list'>
              <div className='title'>Port Orders</div>
              <div className='orders'>
                {_.map(_.get(this.context.order, 'vs.in.portorders'), (order, i) ->
                  <div className='order' key={i}>
                    <div className='details' onClick={react.submitModal.bind(null, i)}>{order.btn}</div>
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
          <li className={this.continueClass()}><a href='javascript:void(0)' onClick={this.context.nav.bind(null, 'continue', this.props.route.path)}>{this.context.continueText('port_numbers')}</a></li>
        </ul>
      </div>
    </div>
