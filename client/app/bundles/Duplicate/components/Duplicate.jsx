import React, { PropTypes, Component } from 'react'
import LoadingForm from '../../GenericForm/containers/LoadingForm'


export default class Duplicate extends Component {
  render() {
    const {
      model, id, heading
    } = this.props

    return(
      <div className='content Duplicate'>
        <h3 className="page-title">{heading}</h3>
        <LoadingForm forceCreate model={model} editId={id} />
      </div>
    )
  }
}
