import { compose, createStore, applyMiddleware, combineReducers } from 'redux'
import loggerMiddleware from 'lib/middlewares/loggerMiddleware'

import rootReducer, { initialStates } from '../reducers'
import addEntities from '../actions/addEntities'

function initialDispatches(dispatch, props) {
  dispatch(addEntities({
    authToken: props.authToken,
    users: props.users,
    time_allocations: props.time_allocations,
    start_year: props.start_year,
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
