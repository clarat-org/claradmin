import React, { PropTypes, Component } from 'react'
import { Link } from 'react-router'
import isArray from 'lodash/isArray'
import AssociationItems from '../containers/AssociationItems'

export default class ShowItems extends React.Component {
  render() {
    const {
      model_instance, associations, column_names, loaded
    } = this.props
    
    if(loaded){
      return (
        <div className="content ShowList">
          <div className="panel-group">
            <h5>Eigene Felder</h5>
            {column_names.map(field_name =>
              this.renderField(field_name, model_instance[field_name])
            )}
          </div>
          <AssociationItems model_instance={model_instance} associations={associations}/>
        </div>
      )
    }
    else{
      return <div className='text-center'>Lade...</div>
    }
  }

  renderField(name, content){
    return(
      <div key={name} className="panel panel-default">
        <div key={`${name}-heading`} className="panel-heading show--panel">
          <h3 className="panel-title">{name}</h3>
        </div>
        <div key={name} className="panel-body show--panel">
          {content.toString()}
        </div>
      </div>
    )
  }
}
