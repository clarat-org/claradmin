import { connect } from 'react-redux'
import moment from 'moment'
import valuesIn from 'lodash/valuesIn'

import { getAllocationForWeekAndUser } from '../../../lib/timeAllocations'
import changeFormData from '../actions/changeFormData'
import TimeAllocationRow from '../components/TimeAllocationRow'

const mapStateToProps = (state, ownProps) => {
  const user_id = ownProps.user.id
  const week_number = ownProps.week_number
  const year = ownProps.year
  const [existing_wa, isHistorical, allocation] = getAllocationForWeekAndUser(
    valuesIn(state.time_allocations), week_number, year, user_id
  )
  const [action, method] = getFormTarget(existing_wa, allocation)
  const [shortOrigin, originTitle] =
    getOriginText(existing_wa, isHistorical, allocation)

  const isPast = moment().year(year).week(week_number).isBefore(
    moment().startOf('week')
  )

  return {
    formId: `form${user_id}`,
    authToken: state.authToken,
    action,
    method,
    user_id,
    desired_wa_hours: allocation.desired_wa_hours,
    actual_wa_hours: allocation.actual_wa_hours,
    week_number,
    year,
    existing_wa,
    shortOrigin,
    originTitle,
    isPast,
	}
}

function getFormTarget(isEdit, allocation) {
  if (isEdit) {
    return [`/time_allocations/${allocation.id}`, 'PATCH']
  } else {
    return ['/time_allocations', 'POST']
  }
}

function getOriginText(existing_wa, isHistorical, allocation) {
  if (existing_wa) {
    return ['Diese KW', 'In der aktuell gewählten KW neu bestimmt.']
  } else if (isHistorical) {
    return [
      `KW${allocation.week_number}/${allocation.year}`,
      'Aus der nächsten historischen KW übernommene Zeit.'
    ]
  } else {
    return ['keine', 'Es gibt für diesen Nutzer keine früheren Daten']
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  onInputChange: (field) => {
    return (e) => {
      dispatch(changeFormData(field, e.target.value))
    }
  }
})

export default connect(mapStateToProps, mapDispatchToProps)(TimeAllocationRow)
