import React, { PropTypes } from 'react'
import TimeSpanSelectionContainer from '../containers/TimeSpanSelectionContainer'
import TimeAllocationRowContainer from '../containers/TimeAllocationRowContainer'

export default class Root extends React.Component {
  static propTypes = {
    users: PropTypes.arrayOf(PropTypes.object).isRequired,
    start_year: PropTypes.number.isRequired,
    time_allocations: PropTypes.arrayOf(PropTypes.object).isRequired,
  }

  render() {
    const { users, start_year, time_allocations } = this.props

    return (
      <div className="TimeAllocationTable form-inline">
        <TimeSpanSelectionContainer start_year={start_year} />
        <table className='table table-condensed'>
          <tbody>
            <tr>
              <th>Nutzer</th>
              <th>Info-Herkunft</th>
              <th>W&A Stunden</th>
              <th>Aktion</th>
            </tr>
            {users.map(user => {
              return (
                <TimeAllocationRowContainer
                  key={user.id} user={user} time_allocations={time_allocations}
                />
              )
            })}
          </tbody>
        </table>
      </div>
    )
  }
}
