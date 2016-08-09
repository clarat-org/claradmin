import { compose, createStore, applyMiddleware, combineReducers } from 'redux'
import loggerMiddleware from 'lib/middlewares/loggerMiddleware'

import rootReducer, { initialStates } from '../reducers'
import addEntities from '../actions/addEntities'

function initialDispatches(dispatch, props) {
  dispatch(addEntities({
    teams: props.teams,
    target_models: props.target_models,
    target_field_names: props.target_field_names,
    target_field_values: props.target_field_values
  }))
}

export default function getStore(props) {
	const store = createStore(
		rootReducer,
		initialStates,
		applyMiddleware(
			// thunkMiddleware,
      loggerMiddleware // for debugging
		)
	)

  initialDispatches(store.dispatch, props)

  return store
}
