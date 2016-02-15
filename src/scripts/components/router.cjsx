Router  = ReactRouter.Router
Route   = ReactRouter.Route
Index   = ReactRouter.IndexRoute
History = ReactRouter.hashHistory

RouterComponent = React.createClass
  render: ->
    <Router history={History}>
      <Route path="/" component={AppComponent}>
        <Route path="order/:ident" component={OrderComponent}>
          <Route path="service_type" component={ServiceTypeComponent} />
          <Route path="service_address" component={ServiceAddressComponent} />
          <Route path="ip_addresses" component={IPAddressesComponent} />
          <Route path="existing_numbers" component={ExistingNumbersComponent} />
          <Route path="new_numbers" component={NewNumbersComponent} />
          <Route path="port_numbers" component={PortNumbersComponent} />
          <Route path="number_features" component={NumberFeaturesComponent} />
          <Route path="review" component={ReviewComponent} />
        </Route>
        <Route path="list" component={ListComponent} />
      </Route>
    </Router>
