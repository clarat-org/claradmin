import React from 'react'
import BurnUpChartContainer from '../containers/BurnUpChartContainer'

export default class ProductivityGoalPage extends React.Component {
  render() {
    return (
      <div className='jumbotron chart'>
        <h2>Produktivitääät</h2>
        <BurnUpChartContainer />
      </div>
    )
  }
}
