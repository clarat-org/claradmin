import { compose, createStore, applyMiddleware, combineReducers } from 'redux'
import loggerMiddleware from 'lib/middlewares/loggerMiddleware'

import rootReducer, { initialStates } from '../reducers'
import addEntities from '../actions/addEntities'

function initialDispatches(dispatch, props) {
  dispatch(addEntities({
    productivity_goal: props.productivity_goal,
    statistics: props.statistics,
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
