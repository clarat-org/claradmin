import React, { PropTypes, Component } from 'react'
import isArray from 'lodash/isArray'

export default class TableCell extends Component {
  render() {
    const {
      content, contentType
    } = this.props

    return (
      <td>
        {this.renderContent(content, contentType)}
      </td>
    )
  }

  renderContent(content) {
    switch(typeof content) {
      case 'object':
        if(isArray(content)){
          return(
            <p>
              {content.map(obj => obj['label']).join(', ')}
            </p>
          )
        } else {
          return content
        }
      case 'boolean':
        if (content) {
          return <span className='fui-check' title='Ja' />
        } else {
          return <span className='fui-cross' title='Nein' />
        }
      case 'string':
        return content.substr(0, 100)
      case 'time':
        return new Date(content).toLocaleString('de-de')
      default:
        return content
    }
  }
}
