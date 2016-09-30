import { connect } from 'react-redux'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import valuesIn from 'lodash/valuesIn'
import Show from '../components/Show'

const mapStateToProps = (state, ownProps) => {
  const pathname = ownProps.location.pathname
  const model = pathname.split('/')[1]

  return {
    model,
    model_instance: valuesIn(state.entities[model]).filter(instance =>
      instance.id == ownProps.params.id
    )[0],
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

    loadData() {
      const singularModel =
        stateProps.model.substr(0, stateProps.model.length - 1)

      dispatchProps.dispatch(
        loadAjaxData(
          'field_set/' + singularModel, {}, 'field_set', transformResponse
        )
      )
      // just load more stuff here
      // dispatchProps.dispatch(
      //   loadAjaxData(
      //     'field_set/' + singularModel, {}, 'field_set', transformResponse
      //   )
      // )
      )
    }
  }
}

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(Show)
