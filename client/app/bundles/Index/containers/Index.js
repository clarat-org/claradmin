import { connect } from 'react-redux'
import loadAjaxData from '../../..//Backend/actions/loadAjaxData'
import Index from '../components/Index'

const mapStateToProps = (state, ownProps) => {
  const pathname = ownProps.location.pathname
  const model = pathname.substr(1, pathname.length)
  return {
    model,
    heading: headingFor(model),
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch
})

const mergeProps = (stateProps, dispatchProps, ownProps) => ({
  ...stateProps,
  ...dispatchProps,
  ...ownProps,

  loadData(query = ownProps.location.query, nextModel = stateProps.model) {
    dispatchProps.dispatch(
      loadAjaxData(nextModel, query, 'indexResults')
    )
  }
})

function headingFor(model) {
  switch(model) {
  case 'offer_translations':
    return 'Angebotsübersetzungen'
  case 'organization_translations':
    return 'Orga-Übersetzungen'
  }
}

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(Index)
