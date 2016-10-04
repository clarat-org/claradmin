import { connect } from 'react-redux'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import Show from '../components/Show'

const mapStateToProps = (state, ownProps) => {
  const id = ownProps.params.id
  const pathname = ownProps.location.pathname
  const model = pathname.split('/')[1]
  const heading = model.substr(0, model.length - 1) + '#' + id

  return {
    id,
    model,
    heading
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch
})

const mergeProps = (stateProps, dispatchProps, ownProps) => {
  // This response does not follow JSON API format, we need to transform it
  // manually
  const transformResponse = function(apiResponse) {
    let object = { field_sets: {} }
    object.field_sets[stateProps.model] = apiResponse
    return object
  }

  return {
    ...stateProps,
    ...dispatchProps,
    ...ownProps,

    loadData(propsToLoad = stateProps) {
      const singularModel =
        propsToLoad.model.substr(0, propsToLoad.model.length - 1)
      const modelKey = `${propsToLoad.model}`
      // console.log('Data Load: ' + modelKey + propsToLoad.id)

      // load field_set (all fields and associations of current model)
      dispatchProps.dispatch(
        loadAjaxData(
          'field_set/' + singularModel, {}, 'field_set', transformResponse
        )
      )
      // load data of current model_instance
      dispatchProps.dispatch(
        loadAjaxData(`${modelKey}/${propsToLoad.id}`, '', modelKey)
      )
    }
  }
}

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(Show)
