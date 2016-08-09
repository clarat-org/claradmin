import merge from 'lodash/object/merge'

export const initialState = {
  teams: {},
}

export default function entityReducer(state = initialState, action) {
  switch (action.type) {
    case 'ADD_ENTITIES':
      return merge({}, state, action.entities)
    break

    default:
      return state;
  }
}
