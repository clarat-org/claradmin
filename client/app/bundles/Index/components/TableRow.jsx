import React, { PropTypes, Component } from 'react'
import TableCell from './TableCell'

export default class TableRow extends Component {
  render() {
    const {
      fields, row, actions
    } = this.props

    return (
      <tr>
        {fields.map(field =>
          <TableCell key={field} content={row[field]} />
        )}
          <td>
          {actions.map(action => {
            return(
              <a key={action.href} href={action.href}>
                <span className={action.icon} />
              </a>
            )
          })}
        </td>
      </tr>
    )
  }
}
