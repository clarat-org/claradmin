# frozen_string_literal: true
module API::V1
  module OrganizationTranslation
    module Representer
      class Show < API::V1::Default::Representer::Show
        property :label, getter: ->(ot) do
          "##{ot[:represented].id} (#{ot[:represented].locale})"
        end
        property :organization_id
        property :locale
        property :source
        property :name
        property :description
        property :possibly_outdated
        property :created_at
        property :updated_at

        property :organization_section, getter: ->(ot) do
          ot[:represented].organization.section_filters.pluck(:identifier)
        end
      end

      class Index < API::V1::Default::Representer::Index
        items extend: Show
      end
    end
  end
end
