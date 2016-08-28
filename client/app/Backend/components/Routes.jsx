import React, { PropTypes } from 'react'
import { Router, Route, browserHistory, IndexRoute } from 'react-router'

import Layout from './Layout'
import Index from '../../bundles/Index/containers/Index'
import DashboardContainer
  from '../../bundles/Dashboard/containers/DashboardContainer'
import ShowProductivityGoalContainer
  from '../../bundles/ShowProductivityGoal/containers/ShowProductivityGoalContainer'
import TimeAllocationTableContainer
  from '../../bundles/TimeAllocationTable/containers/TimeAllocationTableContainer'

export default class Routes extends React.Component {
  render() {
    return (
      <Router history={browserHistory}>
        <Route path='/' component={Layout}>
          <IndexRoute component={DashboardContainer}/>

          <Route path='productivity_goals'>
            <Route path=':id' component={ShowProductivityGoalContainer} />
          </Route>

          <Route path='time_allocations'>
            <IndexRoute component={TimeAllocationTableContainer}/>
            <Route path=':year/:week_number' component={TimeAllocationTableContainer} />
          </Route>

          <Route path='offer_translations'>
            <IndexRoute component={Index} />
          </Route>

          <Route path='organization_translations'>
            <IndexRoute component={Index} />
          </Route>
        </Route>
      </Router>
    )
  }
}
