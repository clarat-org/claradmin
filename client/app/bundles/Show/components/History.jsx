import React, { PropTypes, Component } from 'react'
import CollapsiblePanel
  from '../../CollapsiblePanel/containers/CollapsiblePanel'

export default class History extends React.Component {
  componentDidMount() {
    this.props.loadData()
  }

  render() {
    const { hasHistory, historyItems } = this.props
    if (!hasHistory) return null

    return(
      <CollapsiblePanel title='History' visible={false}>
        <div key={name} className="panel-body show--panel">
          {historyItems.map(this.renderHistoryItem.bind(this))}
        </div>
      </CollapsiblePanel>
    )
  }

  renderHistoryItem(item) {
    return(
      <div
        key={item.id}
        className="History-Item panel panel-default container-fluid"
      >
        <h6>{item.event}</h6>
        <div className='History-Who col-sm-6'>
          Von: {item.user.label}
        </div>
        <div className='History-When col-sm-6'>
          Am: {item['created-at']}
        </div>
        <table className='table History-What'>
          <tbody>
            {item.changes.map(this.renderHistoryChange.bind(this))}
          </tbody>
        </table>
      </div>
    )
  }

  renderHistoryChange(change) {
    return(
      <tr key={change.field}>
        <td>{change.field}</td>
        <td>{this.textOrIcon(change.before)}</td>
        <td>{this.textOrIcon(change.after)}</td>
      </tr>
    )
  }

  textOrIcon(text) {
    if (text) return text
    return <span className='fa fa-minus-circle' />
  }
}
