import React, { PropTypes } from 'react'
import FormContainer from '../containers/FormContainer'
import PreviewBurnUpChart from '../containers/PreviewBurnUpChart'

export default class Root extends React.Component {
  render() {
    return (
      <div className="NewProductivityGoal">
        <div className="chart">
          <PreviewBurnUpChart />
        </div>
        <FormContainer />
      </div>
    )
  }
}
