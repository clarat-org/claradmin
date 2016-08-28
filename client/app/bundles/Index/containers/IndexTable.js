import { connect } from 'react-redux'
import settings from '../../../lib/settings'
import IndexTable from '../components/IndexTable'

const mapStateToProps = (state, ownProps) => {
  const fields = settings.index[ownProps.model].fields
  const rows = state.ajax.indexResults || []
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
