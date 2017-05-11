export default {
  index: {
    assignable: {
      assignment_actions: [
        'assign_someone_else', 'retrieve_assignment', 'assign_to_system',
        'assign_to_current_user'
      ]
    },

    offer_translations: {
      fields: [
        'id', 'offer_id', 'locale', 'source', 'name',
        'possibly_outdated', {offer: ['approved_at', 'created_by']}
      ],
      general_actions: [
        'index', 'export'
      ],
      member_actions: [
        'show', 'edit'
      ]
    },

    organization_translations: {
      fields: [
        'id', 'organization_id', 'locale', 'source', 'description',
        'possibly_outdated', {organization: ['approved_at']}
      ],
      general_actions: [
        'index', 'export'
      ],
      member_actions: [
        'show', 'edit'
      ]
    },

    statistic_charts: {
      fields: [
        'id', 'title', 'ends_at', 'target_model', 'target_field_name'
      ],
      general_actions: [
        'index', 'new'
      ],
      member_actions: [
        'show'
      ]
    },

    offers: {
      fields: [
        'id', 'name', 'aasm_state', 'created_by', 'expires_at',
        'logic_version_id', { section: ['name'] }
      ],
      general_actions: [
        'index', 'export'
      ],
      member_actions: [
        'show'
      ]
    },

    locations: {
      fields: [
        'id', 'name', 'street', 'addition', 'zip', 'hq', 'visible', 'in_germany',
        { federal_state: ['label'] }, { organization: ['label'] },
        { city: ['label'] }
      ],
      general_actions: [
        'index', 'export', 'new'
      ],
      member_actions: [
        'show'
      ]
    },

    cities: {
      fields: [
        'id', 'name'
      ],
      general_actions: [
        'index', 'export', 'new'
      ],
      member_actions: [
        'show'
      ]
    },

    federal_states: {
      fields: [
        'id', 'name'
      ],
      general_actions: [
        'index', 'export',
      ],
      member_actions: [
        'show'
      ]
    },

    contact_people: {
      fields: [
        'id', 'first_name', 'last_name', { organization: ['label'] },
        { email: ['label'] }, 'area_code_1', 'local_number_1', 'area_code_2',
        'local_number_2'
      ],
      general_actions: [
        'index', 'export', 'new'
      ],
      member_actions: [
        'show'
      ]
    },

    emails: {
      fields: [
        'id', 'address'
      ],
      general_actions: [
        'index', 'export', 'new'
      ],
      member_actions: [
        'show'
      ]
    },

    users: {
      fields: [
        'id', 'name', 'email', { user_teams: ['name'] }
      ],
      general_actions: [
        'index'
      ],
      member_actions: [
        'show'
      ]
    },

    organizations: {
      fields: [
        'id', 'offers_count', 'name', 'aasm_state', 'locations_count'
      ],
      general_actions: [
        'index', 'export', 'new'
      ],
      member_actions: [
        'show'
      ]
    },

    divisions: {
      fields: [
        'id', 'name', { organization: ['name'] }
      ],
      general_actions: [
        'index', 'export', 'new'
      ],
      member_actions: [
        'show'
      ]
    },

    user_teams: {
      fields: [
        'id', 'name', 'classification', { users: ['name'] }
      ],
      general_actions: [
        'index', 'new',
      ],
      member_actions: [
        'show', 'edit'
      ]
    },

    assignments: {
      fields: [
        'id', 'assignable_id', 'assignable_type', 'creator_id', 'creator_team_id',
        'receiver_id', 'receiver_team_id', 'message', 'topic', 'aasm_state',
        'created_at'
      ],
      inline_fields: [
        'assignable_type', 'assignable_id', 'topic',
        {assignable: ['label', 'created_at']},
        {creator: ['name']}, 'message', 'created_at'
      ],
      general_actions: [
        'index'
      ],
      member_actions: [
        'edit_assignable'
      ]
    },
  },

  OPERATORS: ['=', '!=', '<', '>'],

  SECTIONS: ['family', 'refugees'],
}
