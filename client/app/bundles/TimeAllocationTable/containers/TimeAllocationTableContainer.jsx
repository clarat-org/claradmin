import { connect } from 'react-redux'
import moment from 'moment'
import TimeAllocationTable from '../components/TimeAllocationTable'

const mapStateToProps = (state, ownProps) => ({
  users: state.users,
  year: Number(ownProps.params.year) || moment().year(),
  week_number: Number(ownProps.params.week_number) || moment().week(),
})

const mapDispatchToProps = (dispatch, ownProps) => ({
})

export default connect(mapStateToProps, mapDispatchToProps)(TimeAllocationTable)
