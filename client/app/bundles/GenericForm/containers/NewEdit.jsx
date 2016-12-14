import { connect } from 'react-redux'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import setUi from '../../../Backend/actions/setUi'
import NewEdit from '../components/NewEdit'

const mapStateToProps = (state, ownProps) => {
  let model, idOrNew, edit
  if (ownProps.location) {
    const pathname = ownProps.location.pathname
    let [_, model, idOrNew, edit] = pathname.split('/')
  } else {
    let { model, idOrNew, edit } = ownProps
  }
  const editId = edit ? idOrNew : null
  const heading = headingFor(model, editId)
  const uiDataLoadedFlag = `GenericForm-edit-loaded-${model}-${editId}`
  const loadedOriginalData = state.ui[uiDataLoadedFlag] || false

  return {
    heading,
    model,
    editId,
    loadedOriginalData,
    uiDataLoadedFlag,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch
})

const mergeProps = (stateProps, dispatchProps, ownProps) => {
  return {
    ...stateProps,
    ...dispatchProps,
    ...ownProps,

    loadData() {
      const { model, editId } = stateProps
      if (!editId) return

      dispatchProps.dispatch(
        loadAjaxData(
          `${model}/${editId}`, '', model, undefined, undefined, () => {
            dispatchProps.dispatch(setUi(stateProps.uiDataLoadedFlag, true))
          }
        )
      )
    },
  }
}

function headingFor(model, id) {
  let heading
  switch(model) {
  case 'user_teams':
    heading = 'Team'
    break
  case 'divisions':
    heading = 'Abteilung'
    break
  default:
    throw new Error(`Please provide a GenericForm heading for ${model}`)
  }
  return heading + ( id ? ` #${id} bearbeiten` : ' anlegen' )
}


export default connect(
  mapStateToProps,
  mapDispatchToProps,
  mergeProps,
)(NewEdit)
