import { connect } from 'react-redux'
import { values } from 'lodash'
import removeFlashMessage from '../actions/removeFlashMessage'
import FlashMessageList from '../components/FlashMessageList'

const mapStateToProps = (state) => {
  console.log(state)
  return {
    messages: values(state.flashMessages)
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    onMessageExpire: function(id) {
      dispatch(removeFlashMessage(id))
    }
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(FlashMessageList)
