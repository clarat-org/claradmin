import React, { PropTypes } from 'react'
import OverviewPanel from '../containers/OverviewPanel'
import StatisticsContainer from '../containers/StatisticsContainer'
import CollapsiblePanel from '../../CollapsiblePanel/containers/CollapsiblePanel'
import ActualWaList from './ActualWaList'

export default class Dashboard extends React.Component {
  static propTypes = {
    hasOutstandingTimeAllocations: PropTypes.bool.isRequired,
    outstandingTimeAllocations: PropTypes.array.isRequired,
  }

  render() {
    const {
      user, hasOutstandingTimeAllocations, outstandingTimeAllocations,
    } = this.props

    const actualWa = hasOutstandingTimeAllocations ? (
      <ActualWaList outstandingTimeAllocations={outstandingTimeAllocations} />
    ) : null

    return (
      <div className='Dashboard'>
        <h1>Dashboard</h1>
        <hr />
        {actualWa}
        <CollapsiblePanel
          title={`Willkommen, ${user.name}`} identifier='dashboard'
          visible={true}
        >
          <OverviewPanel />
        </CollapsiblePanel>
        <CollapsiblePanel
          title='W&A Statistiken' identifier='overall-statistic-charts'
          visible={false}
        >
          <StatisticsContainer />
        </CollapsiblePanel>
      </div>
    )
  }
}
