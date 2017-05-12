# frozen_string_literal: true
module API::V1
  module FederalState
    module Representer
      class Show < API::V1::Default::Representer::Show
        include Roar::JSON::JSONAPI.resource :federal_states

        attributes do
          property :name
          property :label, getter: ->(federal_state) {
            federal_state[:represented].name
          }
          property :created_at
          property :updated_at
        end
      end

      class Index < Show
      end
    end
  end
end
