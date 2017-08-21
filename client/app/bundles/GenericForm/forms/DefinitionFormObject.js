import { FormObject, JsonApiAdapter } from 'rform'

export default class DefinitionFormObject extends FormObject {
  static get model() {
    return 'definition'
  }

  static get type() {
    return 'definitions'
  }

  static get properties() {
    return [
      'key', 'explanation'
    ]
  }

  static get formConfig() {
    return {
      key: { type: 'text' },
      explanation: { type: 'text' }
    }
  }

  static get ajaxAdapter() {
    return JsonApiAdapter
  }

  validation() {
    this.required('key').filled()
    this.required('explanation').filled()
  }
}
