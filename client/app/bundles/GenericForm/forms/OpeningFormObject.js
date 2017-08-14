import { FormObject, JsonApiAdapter } from 'rform'

export default class OpeningFormObject extends FormObject {
  static get model() {
    return 'opening'
  }

  static get type() {
    return 'openings'
  }

  static get properties() {
    return [
      'day', 'open', 'close'
    ]
  }

  static get formConfig() {
    return {
      day: { type: 'select',
      options: ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun']
      },
      open: { type: 'time' },
      close: { type: 'time' }
    }
  }

  static get ajaxAdapter() {
    return JsonApiAdapter
  }

  validation() {
    this.required('day').filled()
  }
}
