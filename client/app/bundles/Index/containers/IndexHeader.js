import { connect } from 'react-redux'
import merge from 'lodash/merge'
import clone from 'lodash/clone'
import pickBy from 'lodash/pickBy'
import toPairs from 'lodash/toPairs'
import { encode } from 'querystring'
import { browserHistory } from 'react-router'
import IndexHeader from '../components/IndexHeader'

const mapStateToProps = (state, ownProps) => {
  const filters = toPairs(
    pickBy(ownProps.params, (value, key) => key.substr(0, 6) == 'filter')
  )
  console.log(ownProps.params)
  const plusButtonDisabled = ownProps.params.hasOwnProperty('filter[id]')

  return {
    ...ownProps.params,
    filters,
    plusButtonDisabled,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  onQueryChange(event) {
    const params = merge(clone(ownProps.params), { query: event.target.value })
    browserHistory.replace(`/${ownProps.model}?${encode(params)}`)
  },

  onPlusClick(event) {
    let params = clone(ownProps.params)
    if (params['filter[id]']) return // ID filtered - other filters not needed
    merge(params, { 'filter[id]': '' })
    browserHistory.replace(`/${ownProps.model}?${encode(params)}`)
  }
})

export default connect(mapStateToProps, mapDispatchToProps)(IndexHeader)
