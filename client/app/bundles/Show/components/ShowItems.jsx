import React, { PropTypes, Component } from 'react'

export default class Show extends React.Component {
  render() {
    const {
      model_instance, associations, column_names
    } = this.props

    return (
      <div className="content Show">
        <h4>Eigene Felder</h4>
        <fieldset>
          {this.renderItems(column_names)}
        </fieldset>
        <h4>Verknüpfte Modelle</h4>
        {associations.map(([association_name, association_columns]) => {
          return(
            <fieldset key={association_name}>
              <legend>{association_name}</legend>
              {this.renderItems(association_columns)}
            </fieldset>
          )
        })}
      </div>
    )
  }

  renderItems(column_names) {
    return column_names.map(column_name =>
      this.renderSingleItem(column_name)
    )
  }

  renderSingleItem(column_name) {
    return(
      <div key={column_name}>
        {column_name}: {this.props.model_instance[column_name]}
      </div>
    )
  }
}
