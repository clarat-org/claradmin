import { connect } from 'react-redux'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import EditTranslation from '../components/EditTranslation'

const mapStateToProps = (state, ownProps) => {
  const id = ownProps.params.id
  const model = ownProps.route.model
  const translation = state[model + '_translations'] && state[model + '_translations'][id]
  const source = state[model + 's'] && state[model + 's'][translation[`${model}_id`]]
  const loaded = !!translation

  let heading
  if (model == 'offer') {
    heading = `Übersetzung von Angebot #${id}`
  } else {
    heading = `Übersetzung von Organisation #${id}`
  }

  return {
    id,
    model,
    loaded,
    source,
    heading,
    translation,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch,
})

const mergeProps = (stateProps, dispatchProps, ownProps) => ({
  ...stateProps,
  ...dispatchProps,
  ...ownProps,

  loadData() {
    const translationKey = `${stateProps.model}_translations`
    dispatchProps.dispatch(
      loadAjaxData(`${translationKey}/${stateProps.id}`, '', translationKey)
    )
  }
})

export default connect(
  mapStateToProps,
  mapDispatchToProps,
  mergeProps
)(EditTranslation)
