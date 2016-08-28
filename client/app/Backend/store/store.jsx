import { compose, createStore, applyMiddleware, combineReducers } from 'redux'
import loggerMiddleware from 'lib/middlewares/loggerMiddleware'
import thunkMiddleware from 'redux-thunk'

import rootReducer, { initialStates } from '../reducers'
import addEntities from '../actions/addEntities'

function initialDispatches(dispatch, props) {
  dispatch(addEntities({
    user_teams: props.user_teams,
    users: props.users,
    current_user: props.current_user,

    productivity_goals: props.productivity_goals,
    statistics: props.statistics,
    time_allocations: props.time_allocations,

    start_year: props.start_year,
    authToken: props.authToken,
  }))
}

export default function getStore(props) {
	const store = createStore(
		rootReducer,
		initialStates,
		applyMiddleware(
			thunkMiddleware,
      loggerMiddleware // for debugging
		)
	)

  initialDispatches(store.dispatch, props)

  return store
}
