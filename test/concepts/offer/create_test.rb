# frozen_string_literal: true
require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'

class OfferCreateTest < ActiveSupport::TestCase
  include OperationTestUtils

  it 'gets created with submodels' do
    params = {
      data: {
        type: 'offers',
        attributes: {
          name: 'Kaperfahrt',
          description: 'yarr',
          encounter: 'personal'
        },
        relationships: {
          'contact-people': {
            data: [
              {
                type: 'contact-people',
                attributes: {
                  'first-name': 'Edward',
                  'last-name': 'Thatch',
                  'operational-name': 'Blackbeard',
                  'responsibility': 'Captain'
                },
                relationships: {
                  organization: {
                    data: { type: 'organizations', id: '1' }
                  }
                }
              }
            ]
          },
          'language-filters': { data: [{ type: 'filters', id: '1' }] },
          location: { data: { type: 'locations', id: '1' } },
          'split-base': { data: { type: 'split-bases', id: '1' } },
          section: { data: { type: 'sections', id: '1' } }
        }
      }
    }

    result =
      api_operation_must_work API::V1::Offer::Create, params.to_json
    result['model'].name.must_equal 'Kaperfahrt'
    result['model'].description.must_equal 'yarr'
    result['model'].created_by.must_equal 1 # side effect
    result['model'].contact_people.length.must_equal 1
    result['model'].contact_people.first.responsibility.must_equal 'Captain'
    result['model'].contact_people.first.operational_name.must_equal 'Blackbeard'
    result['model'].contact_people.first.first_name.must_equal 'Edward'
    result['model'].contact_people.first.last_name.must_equal 'Thatch'
    result['model'].language_filters.length.must_equal 1
    result['model'].location.id.must_equal 1
    result['model'].split_base.id.must_equal 1
    result['model'].section.id.must_equal 1
  end
end
