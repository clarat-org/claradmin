import React, { PropTypes } from 'react'

export default class TimeAllocationRow extends React.Component {
  render() {
    const {
      user, formId, desired_wa_hours, actual_wa_hours, year, week_number,
      action, method, user_id, shortOrigin, originTitle, authToken,
      onInputChange, isPast,
    } = this.props

    const actualInput = isPast ? (
      <td>
        <input
          form={formId} type="number" name="time_allocation[actual_wa_hours]"
          className='form-control' value={actual_wa_hours}
          onChange={onInputChange('actual_wa_hours')}
        />
      </td>
    ) : null


    return (
      <tr>
        <td>
          {user.name}
          <form id={formId} action={action} method="POST">
            <input type='hidden' name='utf8' value='&#x2713;' />
            <input name='_method' type='hidden' value={method} />
            <input name='authenticity_token' type='hidden' value={authToken} />
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
            form={formId} type="number" name="time_allocation[desired_wa_hours]"
            className='form-control' value={desired_wa_hours}
            onChange={onInputChange('desired_wa_hours')}
          />
        </td>
        {actualInput}
        <td>
          <button form={formId} type='submit' className='btn btn-default btn-sm'>
            Speichern
          </button>
        </td>
      </tr>
    )
  }
}
