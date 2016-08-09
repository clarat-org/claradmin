import merge from 'lodash/object/merge'
import moment from 'moment'

export const initialState = {
  year: moment().year(),
  week_number: moment().week(),
  forms: {},
}

export default function formReducer(state = initialState, action) {
  switch (action.type) {
    case 'CHANGE_YEAR':
      return merge({}, state, {year: Number(action.year)})
    break

    case 'CHANGE_WEEK_NUMBER':
      return merge({}, state, {week_number: Number(action.week_number)})
    break

    case 'CHANGE_FORM_DATA':
      let forms = {}
      forms[action.formId] = {}
      forms[action.formId][action.name] = action.value
      return merge({}, state, {forms})
    break

    default:
      return state;
  }
}
