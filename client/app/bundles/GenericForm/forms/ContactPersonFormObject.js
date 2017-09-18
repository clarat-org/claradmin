import GenericFormObject from '../lib/GenericFormObject'
import EmailFormObject from './EmailFormObject'

export default class CityFormObject extends GenericFormObject {
  static get model() {
    return 'contact-person'
  }

  static get type() {
    return 'contact-people'
  }

  static get properties() {
    return [
      'gender', 'academic-title', 'position', 'first-name', 'last-name',
      'operational-name', 'responsibility', 'area-code-1', 'local-number-1',
      'area-code-2', 'local-number-2', 'fax-area-code', 'fax-number',
      'email', 'organization', 'spoc',
    ]
  }

  static get formConfig() {
    return {
      'area-code-1': { type: 'string' },
      'local-number-1': { type: 'string' },
      'area-code-2': { type: 'string' },
      'local-number-2': { type: 'string' },
      'fax-area-code': { type: 'string' },
      'fax-number': { type: 'string' },
      'first-name': { type: 'string' },
      'last-name': { type: 'string' },
      'operational-name': { type: 'string' },
      'academic-title': { type: 'select', options: ['', 'dr', 'prof_dr'] },
      gender: { type: 'select', options: ['', 'male', 'female'] },
      responsibility: { type: 'string' },
      position: {
        type: 'select', options: ['', 'superior', 'public_relations', 'other']
      },
      // street: { type: 'string' },
      // 'zip-and-city': { type: 'string' },
      spoc: { type: 'checkbox' },
      organization: { type: 'filtering-select' },
      email: { type: 'creating-select' }
    }
  }

  static get submodels() {
    return ['email', 'organization']
  }

  static get submodelConfig() {
    return {
      email: { relationship: 'oneToOne', object: EmailFormObject },
      organization: { relationship: 'oneToOne' }
    }
  }

  // static get requiredFields() {
  //   return ['organization']
  // }

  validation() {
    // this.required('address').filled()
    // this.required('organization').filled()
  }
}
