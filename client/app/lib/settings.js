export default {
  index: {
    offer_translations: {
      fields: [
        'id', 'offer_id', 'locale', 'source', 'name',
        'possibly_outdated'//, 'updated_at', 'offer_section'
      ],
      actions: [
        'edit'
      ]
    },

    organization_translations: {
      fields: [
        'id', 'offer_id', 'locale', 'source', 'description',
        'possibly_outdated'//, 'updated_at', 'offer_section'
      ],
      actions: [
        'edit'
      ]
    }
  }
}
