import React, { PropTypes, Component } from 'react'
import BurnUpChartContainer from '../../ShowStatisticChart/containers/BurnUpChartContainer'

export default class PersonalStatisticCharts extends Component {
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
              <BurnUpChartContainer statisticChart={chart} />
              <hr />
            </div>
          )
        })
      )
    }
  }
}
