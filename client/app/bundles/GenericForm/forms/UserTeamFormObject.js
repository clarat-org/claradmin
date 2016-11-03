import { FormObject, JsonApiAdapter } from 'rform'

export default class UserTeamFormObject extends FormObject {
  static get model() {
    return 'user_team'
  }

  static get properties() {
    return [
      'name'
    ]
  }

  static get formConfig() {
    return {
      name: { type: 'string' }
    }
  }

  static get ajaxAdapter() {
    return JsonApiAdapter
  }

  validation() {
    this.required('name').filled()
  }
}
