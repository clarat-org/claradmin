# frozen_string_literal: true
module API::V1
  module ContactPersonTranslation
    module Representer
      class Show < API::V1::Assignable::Representer::Show
        type :contact_person_translations

        property :label, getter: ->(ot) do
          "##{ot[:represented].id} (#{ot[:represented].locale})"
        end
        property :contact_person_id
        property :locale
        property :source
        property :responsibility
        property :possibly_outdated
        property :created_at
        property :updated_at
#TODO: needs to be refactored?
        # has_one :organization do
        #   type :organizations
        #
        #   property :id
        #   property :description
        end

        # property :organization_section, getter: ->(ot) do
        #   ot[:represented].organization.section_filters.pluck(:identifier)
        # end
      end

      class Index < Show
      end
    end
  end
end
