import { connect } from 'react-redux'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import InlineIndex from '../components/InlineIndex'
import forIn from 'lodash/forIn'
import size from 'lodash/size'
import merge from 'lodash/merge'
import clone from 'lodash/clone'

const mapStateToProps = (state, ownProps) => {
  let optional =
    ownProps.identifierAddition ? '_' + ownProps.identifierAddition : ''
  const model = ownProps.model
  const identifier = 'indexResults_' + model + optional
  const uiKey = 'index_' + model + optional
  const params =
    merge(
      clone(ownProps.optionalParams),
      merge(clone(state.ui[uiKey]), ownProps.lockedParams)
    )
  const count = state.ajax[identifier] ? state.ajax[identifier].meta.total_entries : 0
  const loaded = state.ajax[identifier] != undefined &&
                 state.ajax.isLoading[identifier] == false &&
                 (params.page == undefined ||
                   params.page ==
                   state.ajax[identifier].meta.current_page)

  return {
    params,
    lockedParams: ownProps.lockedParams,
    model,
    identifier,
    uiKey,
    count,
    loaded
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch
})

const mergeProps = (stateProps, dispatchProps, ownProps) => ({
  ...stateProps,
  ...dispatchProps,
  ...ownProps,

  loadData(query = merge(clone(ownProps.optionalParams), ownProps.lockedParams), nextModel = ownProps.model, loaded = stateProps.loaded) {
    let optional =
      ownProps.identifierAddition ? '_' + ownProps.identifierAddition : ''
    // console.log('loadData')
    // console.log(nextModel)
    // console.log(query)
    if (!loaded) {
      // console.log('LOAD!')
      dispatchProps.dispatch(
        loadAjaxData(nextModel, query, 'indexResults_' + nextModel + optional)
      )
    }
  },

  equalParams(params1, params2) {
    if (size(params1) != size(params2)) return false
    let isSame = true
    forIn(params1, (value, key) => {
      if(!isSame || params2[key] == undefined || params2[key].toString() != value.toString()) {
        isSame = false
      }
    })
    return isSame
  }
})

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(InlineIndex)
