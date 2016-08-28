import { connect } from 'react-redux'
import range from 'lodash/range'
import moment from 'moment'
import { browserHistory } from 'react-router'
import TimeSpanSelection from '../components/TimeSpanSelection'

const mapStateToProps = (state, ownProps) => {
  const selected_year = ownProps.year
  const selected_week_number = ownProps.week_number

  return {
    start_year: state.start_year,
    years: range(state.start_year, state.start_year + 6),
    selected_year,
    week_numbers: range(1, 53),
    selected_week_number,
    selectedWeek:
      moment().year(selected_year).week(selected_week_number).startOf('week'),
	}
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  onYearChange: (e) => {
    browserHistory.push(`/time_allocations/${e.target.value}/${ownProps.week_number}`)
  },

  onWeekNumberChange: (e) => {
    browserHistory.push(`/time_allocations/${ownProps.year}/${e.target.value}`)
  },

  onTodayClick: (_e) => {
    const [year, wn] = [moment().year(), moment().week()]
    browserHistory.push(`/time_allocations/${year}/${wn}`)
  },

  onNextMonthClick: (_e) => {
    const year = moment().year()
    const wn = moment().add(1, 'months').date(1).week()
    browserHistory.push(`/time_allocations/${year}/${wn}`)
  }
})

export default connect(mapStateToProps, mapDispatchToProps)(TimeSpanSelection)
