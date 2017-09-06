import { connect } from 'react-redux'
import { browserHistory } from 'react-router'
import { singularize } from '../../../lib/inflection'
import Duplicate from '../components/Duplicate'

const mapStateToProps = (state, ownProps) => {
  const id = ownProps.params.id
  const pathname = ownProps.location.pathname
  const model = pathname.split('/')[1]
  const heading = `${singularize(model)} #${id} duplizieren`

  return {
    heading,
    model,
    id
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch
})

const mergeProps = (stateProps, dispatchProps, ownProps) => {
  return {
    ...stateProps,
    ...dispatchProps,
    ...ownProps,
  }
}

// const duplicationCustomizations = (model, entity) => { // unused
//   switch(model) {
//   case 'offer':
//     entity['expires-at'] = DateTime.now + 1.year // ...
//     break
//   }
// }

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(Duplicate)
