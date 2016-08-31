import { FormObject, JsonApiAdapter } from 'rform'

export default class ActualWaFormObject extends FormObject {
  static get properties() {
    return ['actual_wa_hours']
  }

  static get model() {
    return 'time_allocation'
  }

  static get ajaxAdapter() {
    return JsonApiAdapter
  }

  validation() {
    this.validates('actual_wa_hours').filled('numericality')
  }
}
