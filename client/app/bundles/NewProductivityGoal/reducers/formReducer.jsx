import merge from 'lodash/merge'
import moment from 'moment'

export const initialState = {
  form: {
    starts_at: moment().format('YYYY-MM-DD'),
    ends_at: moment().add(1, 'month').format('YYYY-MM-DD'),
    target_count: 10,
  },
}

export default function formReducer(state = initialState, action) {
  switch (action.type) {
    case 'CHANGE_FORM_DATA':
      let form = {}
      form[action.name] = action.value
      if (action.name == 'target_model') { form.target_field_name = null }
      if (['target_field_name', 'target_model'].includes(action.name)) {
        form.target_field_value = null
      }
      return merge({}, state, {form})
    break

    default:
      return state;
  }
}
