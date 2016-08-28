import React, { PropTypes } from 'react'
import BurnUpChartContainer from '../containers/BurnUpChartContainer'

export default class ShowProductivityGoal extends React.Component {
  render() {
    return (
      <div className="ShowProductivityGoal">
        <div className='page-header'>
          <h1>Ziel: {this.props.productivity_goal.title}</h1>
        </div>
        <div className="chart">
          <BurnUpChartContainer
            productivity_goal={this.props.productivity_goal}
          />
        </div>
      </div>
    )
  }
}
