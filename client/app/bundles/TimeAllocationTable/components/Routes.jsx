import React, { PropTypes } from 'react'
import { Router, Route, browserHistory, IndexRoute } from 'react-router'
// import Layout from './Layout'
import TimeAllocationTableContainer from '../containers/TimeAllocationTableContainer'

export default class Statistics extends React.Component {
  render() {
    return (
      <Router history={browserHistory}>
        <Route path='time_allocations'>
          <IndexRoute component={TimeAllocationTableContainer}/>
          <Route path=':year/:week_number' component={TimeAllocationTableContainer} />
        </Route>
      </Router>
    )
  }
}
