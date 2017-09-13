import GenericFormObject from '../lib/GenericFormObject'
import { EMAIL_REGEX } from '../lib/formats'

export default class EmailFormObject extends GenericFormObject {
  static get model() {
    return 'email'
  }

  static get type() {
    return 'emails'
  }

  static get properties() {
    return ['address']
  }

  static get formConfig() {
    return {
      address: { type: 'string' }
    }
  }

  validation() {
    this.required('address').filled({ 'format?': EMAIL_REGEX })
  }
}
