import { connect } from 'react-redux'
import setupSubscription from '../actions/setupSubscription'
import changeEntity from '../actions/changeEntity'
import Routes from '../components/Routes'

const mapStateToProps = (state, ownProps) => {
  return {}
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  initialSetup() {
    dispatch(setupSubscription({ channel: 'ChangesChannel' }, {
      received(data) {
        dispatchProps.dispatch(changeEntity(data.model, data.id, data.changes))
      }
    }))
  }
})

export default connect(mapStateToProps, mapDispatchToProps)(Routes)
