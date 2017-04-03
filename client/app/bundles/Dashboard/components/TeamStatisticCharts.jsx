import React, { PropTypes, Component } from 'react'
import TeamStatisticChartContainer from '../../StatisticChartContainer/containers/TeamStatisticChartContainer'

export default class TeamStatisticCharts extends Component {
  componentDidMount() {
    this.props.loadData()
  }

  render() {
    return (
      <div>
        {this.existingChartsOrLoading(this.props.statisticCharts)}
      </div>
    )
  }

  existingChartsOrLoading(charts) {
    if (!charts.length) {
      return (
        <div>Loading... </div>
      )
    } else {
      return (
        charts.map(chart => {
          return(
            <div key={chart.id} className="chart">
              <h4>{chart.title}</h4>
              <TeamStatisticChartContainer statisticChart={chart} />
              <hr />
            </div>
          )
        })
      )
    }
  }
}
