import { FormObject, JsonApiAdapter } from 'rform'
import { URL_REGEX } from '../lib/formats'

export default class WebsiteFormObject extends FormObject {
  static get model() {
    return 'website'
  }

  static get type() {
    return 'websites'
  }

  static get properties() {
    return [
      'host', 'url'
    ]
  }

  static get formConfig() {
    return {
      host: {
        type: 'select',
        options: [
          'own', 'facebook', 'twitter', 'youtube', 'gplus', 'pinterest',
          'document', 'online_consulting', 'chat', 'forum', 'online_course',
          'application_form', 'contact_form', 'other'
        ]
      },
      url: { type: 'string' },
    }
  }

  static get ajaxAdapter() {
    return JsonApiAdapter
  }

  validation() {
    this.required('host').filled()
    this.required('url').filled({ 'format?': URL_REGEX })
  }
}
