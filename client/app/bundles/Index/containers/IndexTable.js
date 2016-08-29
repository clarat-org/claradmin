import { connect } from 'react-redux'
import compact from 'lodash/compact'
import settings from '../../../lib/settings'
import IndexTable from '../components/IndexTable'

const mapStateToProps = (state, ownProps) => {
  const fields = settings.index[ownProps.model].fields
  const resultData = state.ajax.indexResults
  const resultIds = resultData.data.map(datum => datum.id)
  const allOfModel = state[ownProps.model]
  const rows = allOfModel ? compact(resultIds.map(id => allOfModel[id])) : []

  let tbodyClass
  if (state.ajax.isLoading.indexResults) tbodyClass = 'loading'

  return {
    rows,
    fields,
    tbodyClass
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
})

export default connect(mapStateToProps, mapDispatchToProps)(IndexTable)
