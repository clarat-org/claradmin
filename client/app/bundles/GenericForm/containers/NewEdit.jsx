import { connect } from 'react-redux'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import NewEdit from '../components/NewEdit'

const mapStateToProps = (state, ownProps) => {
  const pathname = ownProps.location.pathname
  const [_, model, idOrNew, edit] = pathname.split('/')
  const editId = edit ? idOrNew : null
  const heading = headingFor(model, editId)
  const loadedOriginalData = !!edit && !!state.entities[model][editId]

  return {
    heading,
    model,
    editId,
    loadedOriginalData,
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

      dispatchProps.dispatch(loadAjaxData(`${model}/${editId}`, '', model))
    },
  }
}

function headingFor(model, id) {
  let heading
  switch(model) {
  case 'user_teams':
    heading = 'Team'
    break
  default:
    throw new Error(`Please provide a heading for ${model}`)
  }
  return heading + ( id ? ` #${id} bearbeiten` : ' anlegen' )
}


export default connect(
  mapStateToProps,
  mapDispatchToProps,
  mergeProps,
)(NewEdit)
