import React, { PropTypes, Component } from 'react'
import { Panel } from 'react-bootstrap'

export default class CollapsiblePanel extends Component {
  render() {
    return (
      <Panel collapsible expanded={this.props.open} onClick={this.props.onClick}
        header={this.renderCollapsibleHeader()}
      >
        {this.props.open ? this.props.children : null}
      </Panel>
    )
  }

  renderCollapsibleHeader() {
    return (
      <div>
        {this.props.title}
        {this.renderCollapsibleSymbol()}
      </div>
    )
  }

  renderCollapsibleSymbol() {
    if (this.props.open) {
      return <i className='fui-triangle-up' style={{float: 'right'}} />
    } else {
      return <i className='fui-triangle-down' style={{float: 'right'}} />
    }
  }
}
