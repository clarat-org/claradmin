# frozen_string_literal: true
module API::V1
  module Email
    module Representer
      class Show < API::V1::Default::Representer::Show
        include Roar::JSON::JSONAPI.resource :emails

        attributes do
          property :address
          property :aasm_state
          property :created_at
          property :updated_at

          property :contact_person_ids
          property :offer_ids
          property :organization_ids

          # has_many :contact_people do
          #   type :contact_person
          #   property :id
          #   property :display_name, as: :label
          # end
          #
          # has_many :offers do
          #   type :offer
          #   property :id
          #   property :name, as: :label
          # end
          #
          # has_many :organizations do
          #   type :organization
          #   property :id
          #   property :name, as: :label
          # end

          property :label, getter: ->(email) do
            email[:represented].address
          end
        end
      end

      class Index < Show
      end
    end
  end
end
