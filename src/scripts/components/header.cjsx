Link = ReactRouter.Link

HeaderComponent = React.createClass
  render: ->
    infoBlock =
      <div className='nav info'>
        {unless _.isEmpty(this.props.email) && _.isEmpty(this.props.name)
          <ul className='links'>
            <li>Logged in as <span className='em'>{_.isEmpty(this.props.email) && this.props.name || this.props.email}</span></li>
            <li>Account Balance: <span className='em'>$0</span></li>
            <li><span className='em'>0</span> active calls</li>
          </ul>
        }
      </div>

    <header>
      <div className='right'>
        <div className='nav links'>
          <ul className='links'>
            <li><Link to="/">Dashboard</Link></li>
            <li><Link to="/graphs">Graphs</Link></li>
            <li><Link to="/billing">Billing</Link></li>
            <li><Link to="/orders">Orders & Quotes</Link></li>
            <li><Link to="/cdr">CDR</Link></li>
            <li><Link to="/sms">SMS</Link></li>
            <li><Link to="/lnp">LNP Prequel</Link></li>
            <li><Link to="/api">API</Link></li>
            <li><Link to="/support">Support</Link></li>
            <li><Link to="/logout">Logout</Link></li>
          </ul>
        </div>
        {infoBlock}
      </div>
    </header>
