import { connect } from 'react-redux'
import range from 'lodash/utility/range'
import moment from 'moment'
import { changeWeekNumber, changeYear } from '../actions/changeFormData'
import TimeSpanSelection from '../components/TimeSpanSelection'

const mapStateToProps = (state, ownProps) => {
  return {
    years: range(ownProps.start_year, ownProps.start_year + 6),
    selected_year: state.year,
    week_numbers: range(1, 53),
    selected_week_number: state.week_number,
    selectedWeek: moment().year(state.year).week(state.week_number).startOf('week'),
	}
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  onYearChange: (e) => {
    dispatch(changeYear(e.target.value))
  },

  onWeekNumberChange: (e) => {
    dispatch(changeWeekNumber(e.target.value))
  },

  onTodayClick: (_e) => {
    dispatch(changeWeekNumber(moment().week()))
    dispatch(changeYear(moment().year()))
  },

  onNextMonthClick: (_e) => {
    dispatch(changeWeekNumber(moment().add(1, 'months').date(1).week()))
    dispatch(changeYear(moment().year()))
  }
})

export default connect(mapStateToProps, mapDispatchToProps)(TimeSpanSelection)
