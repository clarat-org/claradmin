import React, { PropTypes, Component } from 'react'
import LoadingForm from '../../GenericForm/containers/LoadingForm'


export default class Duplicate extends Component {
  render() {
    const {
      model, id, heading, modifySeedData, formStateDidMount
    } = this.props

    return(
      <div className='content Duplicate'>
        <h3 className="page-title">{heading}</h3>
        <LoadingForm forceCreate
          modifySeedData={modifySeedData} model={model} editId={id}
          formStateDidMount={formStateDidMount}
        />
      </div>
    )
  }
}
