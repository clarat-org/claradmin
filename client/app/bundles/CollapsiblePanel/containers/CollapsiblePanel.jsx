import { connect } from 'react-redux'
import setUiAction from '../../../Backend/actions/setUi'
import CollapsiblePanel from '../components/CollapsiblePanel'

const mapStateToProps = (state, ownProps) => {
  const uiKey = 'collapsable-panel-' + ownProps.identifier
  const open =
    state.ui[uiKey] === undefined ? ownProps.visible : state.ui[uiKey]

  return {
    open,
    uiKey,
    title: ownProps.title
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch
})

const mergeProps = (stateProps, dispatchProps, ownProps) => ({
  ...stateProps,
  ...dispatchProps,
  ...ownProps,

  onClick(e) {
    dispatchProps.dispatch(setUiAction(stateProps.uiKey, !stateProps.open))
  }
})

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(
  CollapsiblePanel
)
