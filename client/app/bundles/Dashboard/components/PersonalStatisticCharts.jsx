import React, { PropTypes, Component } from 'react'
import BurnUpChartContainer from '../../ShowStatisticChart/containers/BurnUpChartContainer'

export default class PersonalStatisticCharts extends Component {
  componentDidMount() {
    this.props.loadData()
  }

  render() {
    const {
      statisticCharts
    } = this.props

    return (
      <div className="panel panel-default">
        <div className="panel-heading">
          <h3 className="panel-title">Meine Ziele</h3>
        </div>
        <div className="panel-body">
          {statisticCharts.map(chart => {
            return(
              <div key={chart.id} className="chart" style={{border: '1px solid black'}}>
                <BurnUpChartContainer statisticChart={chart} />
              </div>
            )
          })}
        </div>
      </div>
    )
  }
}
