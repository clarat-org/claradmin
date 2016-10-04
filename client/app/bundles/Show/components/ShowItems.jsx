import React, { PropTypes, Component } from 'react'
import { Link } from 'react-router'
import isArray from 'lodash/isArray'

export default class Show extends React.Component {
  render() {
    const {
      model_instance, associations, column_names, loaded
    } = this.props

    if(loaded){
      return (
        <div className="content ShowList">
          <h5>Eigene Felder</h5>
          <div className="panel-group">
            {column_names.map(field_name =>
              this.renderItem(field_name, model_instance[field_name])
            )}
          </div>
          <h5>Verknüpfte Modelle</h5>
          <div className="panel-group">
            {associations.map(([assoc_name, assoc_columns]) =>
              this.renderItem(assoc_name, model_instance[assoc_name])
            )}
          </div>
        </div>
      )
    }
    else{
      return <div className='text-center'>Lade...</div>
    }
  }

  renderItem(name, content){
    return(
      <div key={name} className="panel panel-default">
        <div key={`${name}-heading`} className="panel-heading show--panel">
          <h3 className="panel-title">{name}</h3>
        </div>
        {this.renderContent(name, content)}
      </div>
    )
  }

  renderContent(name, content){
    if(isArray(content)){
      return(
        <div key={name} className="panel-body show--panel">
          {content.map(item => this.renderAssociationItem(name, item))}
        </div>
      )
    }
    else{
      return(
        <div key={name} className="panel-body show--panel">
          {content.toString()}
        </div>
      )
    }
  }

  renderAssociationItem(name, item){
    if(item['id']){
      return(
        <span key={`/${name}/${item['id']}`}>
          <Link key={`/${name}/${item['id']}`} to={`/${name}/${item['id']}`}>
            {item['label']}
          </Link>{', '}
        </span>
      )
    }
    else{
      return(
        <span key={`${name}.${item['label']}`}>
          {item['label']}{', '}
        </span>
      )
    }
  }
}
