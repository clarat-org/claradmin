# frozen_string_literal: true
module API::V1
  module Organization
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :organizations

        attributes do
          property :label, getter: ->(organization) do
            organization[:represented].name
          end

          property :name
          property :description
          property :priority
          property :comment
          property :offers_count
          property :aasm_state
          property :locations_count

          property :website_id
          property :location_ids
          property :contact_person_ids
          property :division_ids
        end

        has_one :website, extend: API::V1::Website::Representer::Show,
                          class: ::Website

        has_many :divisions, extend: API::V1::Division::Representer::Show,
                             class: ::Division
      end
    end
  end
end
