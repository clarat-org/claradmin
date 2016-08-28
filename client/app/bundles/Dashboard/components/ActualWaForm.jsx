import React, { PropTypes } from 'react'
import ActualWaForm from './ActualWaForm'

export default class ActualWaList extends React.Component {
  static propTypes = {
    time_allocation: PropTypes.object.isRequired,
    startDate: PropTypes.string.isRequired,
    endDate: PropTypes.string.isRequired,
    action: PropTypes.string.isRequired,
    authToken: PropTypes.string.isRequired,
  }

  render() {
    const {
      time_allocation, startDate, endDate, action, authToken,
    } = this.props

    return (
      <li className='list-group-item'>
        <div className='row'>
          <div className='col-xs-12 text-center'>
            KW {time_allocation.week_number} / {time_allocation.year + ' '}
            <small>
              ({startDate} - {endDate})
            </small>
          </div>
        </div>
        <div className='row'>
          <div className='col-xs-5 text-center'>
            SOLL: {time_allocation.desired_wa_hours} Stunden
          </div>
          <div className='col-xs-7 text-center'>
            <form
              action={action}
              className='form-inline'
              method='POST'
            >
              <input type='hidden' name='utf8' value='&#x2713;' />
              <input name='authenticity_token' type='hidden' value={authToken} />

              <div className='form-group'>
                <div className='input-group'>
                  <label
                    htmlFor={`actual${time_allocation.week_number}`}
                    className='input-group-addon'
                  >
                    IST
                  </label>
                  <input
                    name='time_allocation[actual_wa_hours]' type='number' min='0'
                    id={`actual${time_allocation.week_number}`}
                    className='form-control'
                  />
                </div>
              </div>
              <button type='submit' className='btn btn-default'>
                Abschicken
              </button>
            </form>
          </div>
        </div>
      </li>
    )
  }
}
