import React, { PropTypes } from 'react'
import FormContainer from '../containers/FormContainer'
import PreviewBurnUpChart from '../containers/PreviewBurnUpChart'

export default class Root extends React.Component {
  render() {
    return (
      <div className='NewProductivityGoal'>
        <div className='page-header'>
          <h1>Neues Produktivitätsziel</h1>
        </div>
        <div className='chart'>
          <PreviewBurnUpChart />
        </div>
        <FormContainer />
      </div>
    )
  }
}
