import React, { PropTypes } from 'react'

export default class TimeAllocationRow extends React.Component {
  render() {
    const {
      user, formId, wa_hours, year, week_number, action, method, user_id,
      shortOrigin, originTitle, authenticity_token, onInputChange,
    } = this.props


    return (
      <tr>
        <td>
          {user.name}
          <form id={formId} action={action} method="POST">
            <input type='hidden' name='utf8' value='&#x2713;' />
            <input name='_method' type='hidden' value={method} />
            <input name='authenticity_token' type='hidden' value={authenticity_token} />
            <input name='time_allocation[user_id]' type='hidden' value={user_id} />
            <input name='time_allocation[year]' type='hidden' value={year} />
            <input name='time_allocation[week_number]' type='hidden' value={week_number} />
          </form>
        </td>
        <td>
          <div title={originTitle}>
            {shortOrigin}
          </div>
        </td>
        <td>
          <input
            form={formId} type="number" name="time_allocation[wa_hours]"
            className='form-control'
            value={wa_hours} onChange={onInputChange}
          />
        </td>
        <td>
          <button form={formId} type='submit' className='btn btn-default btn-sm'>
            Speichern
          </button>
        </td>
      </tr>
    )
  }
}
