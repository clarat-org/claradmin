# frozen_string_literal: true
module API::V1
  module Location
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :locations

        attributes do
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

          property :latitude
          property :longitude
          property :created_at
          property :updated_at
          property :display_name

          property :organization_id
          property :city_id
          property :federal_state_id
          property :offer_ids
        end

        has_one :organization do
          type :organizations
          property :id
          property :name, as: :label
        end

        has_one :federal_state do
          type :federal_states
          property :id
          property :name, as: :label
        end

        has_one :city do
          type :cities
          property :id
          property :name, as: :label
        end
      end

      # class Update < Roar::Decorator
      #   include Roar::JSON::JSONAPI.resource :locations
      #
      #   attributes do
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
      #   end
      # end
    end
  end
end
