import { connect } from 'react-redux'
import toPairs from 'lodash/toPairs'
import ShowItems from '../components/ShowItems'
import settings from '../../../lib/settings'

const mapStateToProps = (state, ownProps) => {
  const showFields = settings.index[ownProps.model].fields
  const field_set =
    state.entities.field_sets && state.entities.field_sets[ownProps.model]
  const column_names = field_set && field_set.column_names || []
  const associations = toPairs(field_set && field_set.associations || {})

  // console.log(showFields)
  // console.log(associations)
  // if(field_set){
  //   console.log(field_set.associations)
  // }

  return {
    model_instance: ownProps.model_instance,
    associations,
    column_names,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
})

export default connect(mapStateToProps, mapDispatchToProps)(ShowItems)
