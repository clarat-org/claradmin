import { connect } from 'react-redux'
import settings from '../../../lib/settings'
import IndexTable from '../components/IndexTable'

const mapStateToProps = (state, ownProps) => {
  const fields = settings.index[ownProps.model].fields
  const resultData = state.ajax.indexResults
  const resultIds = resultData.data.map(datum => datum.id)
  const rows = resultIds.map(id => state[ownProps.model][id])

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
