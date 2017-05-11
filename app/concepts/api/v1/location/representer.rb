# frozen_string_literal: true
module API::V1
  module Location
    module Representer
      class Show < API::V1::Default::Representer::Show
        type :locations

        property :label, getter: ->(location) {
          location[:represented].display_name
        }
        property :display_name
        property :name
        property :street
        property :addition
        property :zip
        property :hq
        property :visible
        property :in_germany

        property :organization_id
        has_one :organization do
          type :organizations
          property :id
          property :name, as: :label
        end

        property :city_id
        has_one :city do
          type :cities
          property :id
          property :name, as: :label
        end

        property :federal_state_id
        has_one :federal_state do
          type :federal_states
          property :id
          property :name, as: :label
        end

        property :offer_ids

        property :latitude
        property :longitude
        property :created_at
        property :updated_at
        property :display_name
      end

      class Index < Show
      end

      # class Update < Roar::Decorator
      #   include Roar::JSON::JSONAPI
      #     type :locations
      #
      #     property :display_name, as: :label
      #     property :name
      #     property :street
      #     property :addition
      #     property :zip
      #     property :hq
      #     property :visible
      #     property :in_germany
      #
      #     property :organization_id
      #     property :city_id
      #     property :federal_state_id
      # end
    end
  end
end
