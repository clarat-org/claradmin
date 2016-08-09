import React, { PropTypes } from 'react'
import BurnUpChartContainer from '../containers/BurnUpChartContainer'

export default class Root extends React.Component {
  render() {
    return (
      <div className="ShowProductivityGoal">
        <div className="chart">
          <BurnUpChartContainer />
        </div>
      </div>
    )
  }
}
