import { connect } from 'react-redux'
import settings from '../../../lib/settings'
import AssociationItems from '../components/AssociationItems'

const mapStateToProps = (state, ownProps) => {
  const model_instance = ownProps.model_instance
  const associations = addValuesToAssociations(ownProps.associations || [], model_instance)

  // console.log(model_instance)
  // console.log(associations)
  // console.log(state)
  // console.log(model_instance)
  // console.log(field_set && field_set.column_names)
  // console.log(column_names)
  // console.log(field_set && field_set.associations)
  // console.log(associations)

  return {
    model_instance,
    associations
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({ })

function addValuesToAssociations(associations) {
  let new_associations = []
  associations.map(([assoc_name, assoc_columns]) => {
    if(settings.index[assoc_name] && settings.index[assoc_name].member_actions){
      new_associations.push([assoc_name, assoc_columns, `/${assoc_name}/`])
    }
    else{
      new_associations.push([assoc_name, assoc_columns, false])
    }
  })
  return new_associations
}

export default connect(mapStateToProps, mapDispatchToProps)(AssociationItems)
