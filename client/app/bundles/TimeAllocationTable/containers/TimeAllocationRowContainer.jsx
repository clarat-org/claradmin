import { connect } from 'react-redux'
import changeFormData from '../actions/changeFormData'
import TimeAllocationRow from '../components/TimeAllocationRow'

const mapStateToProps = (state, ownProps) => {
  const user_id = ownProps.user.id
  const week_number = state.week_number
  const year = state.year
  const [existing_wa, historical, allocation] = getAllocationForUser(
    ownProps.time_allocations, week_number, year, user_id
  )
  const [action, method] = getFormTarget(existing_wa, allocation)
  const [shortOrigin, originTitle] =
    getOriginText(existing_wa, historical, allocation)

  return {
    formId: `form${user_id}`,
    authenticity_token: state.authenticity_token,
    action,
    method,
    user_id,
    wa_hours: allocation.wa_hours,
    week_number,
    year,
    existing_wa,
    shortOrigin,
    originTitle,
	}
}

function getFormTarget(isEdit, allocation) {
  if (isEdit) {
    return [`/time_allocations/${allocation.id}`, 'PATCH']
  } else {
    return ['/time_allocations', 'POST']
  }
}

function getOriginText(existing_wa, historical, allocation) {
  if (existing_wa) {
    return ['Diese KW', 'In der aktuell gewählten KW neu bestimmt.']
  } else if (historical) {
    return [
      `KW${allocation.week_number}/${allocation.year}`,
      'Aus der nächsten historischen KW übernommene Zeit.'
    ]
  } else {
    return ['keine', 'Es gibt für diesen Nutzer keine früheren Daten']
  }
}

function getAllocationForUser(time_allocations, week_number, year, user_id) {
  const allocationsForUser =
    time_allocations.filter(ta => ta.user_id == user_id)

  const existingAllocationForGivenTime = allocationsForUser.filter( ta =>
    ta.week_number == week_number && ta.year == year
  )[0]
  if (existingAllocationForGivenTime) {
    return [true, false, existingAllocationForGivenTime]
  }

  const earlierAllocations = allocationsForUser.filter( ta =>
    ta.year < year || (ta.year == year && ta.week_number <= week_number)
  )
  let closestEarlierAllocation = earlierAllocations.sort( (a, b) => {
    if (a.year > b.year || (a.year == b.year && a.week_number > b.week_number)) {
      return -1
    } else {
      return 1
    }
  })[0]

  if (closestEarlierAllocation) {
    return [false, true, closestEarlierAllocation]
  }

  return [false, false, {wa_hours: 0}]
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  onInputChange: (e) => {
    dispatch(changeFormData('wa_hours', e.target.value))
  }
})

export default connect(mapStateToProps, mapDispatchToProps)(TimeAllocationRow)
