import React, { PropTypes } from 'react'
import { Form, InputSet } from 'rform'

export default class NewForm extends React.Component {
  render() {
    const {
      inputs, seedData, action, method, formId, formObjectClass,
      afterResponse, handleResponse,
    } = this.props

    return (
      <Form ajax requireValid
        method={method} className='form'
        formObjectClass={formObjectClass}
        action={action} id={formId} seedData={seedData}
        handleResponse={handleResponse} afterResponse={afterResponse}
      >
        {inputs.map( (input, index) => {
          return(
            <InputSet key={index}
              wrapperClassName='form-group' className='form-control'
              label={input.attribute} attribute={input.attribute}
              type={input.type}
            />
          )
        })}
        <button className='btn btn-default' type='submit'>
          Abschicken
        </button>
      </Form>
    )
  }
}
