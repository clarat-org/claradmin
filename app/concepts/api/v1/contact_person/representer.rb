# frozen_string_literal: true
module API::V1
  module ContactPerson
    module Representer
      class Show < API::V1::Default::Representer::Show
        include Roar::JSON::JSONAPI.resource :contact_people

        attributes do
          property :area_code_1
          property :local_number_1
          property :area_code_2
          property :local_number_2
          property :fax_area_code
          property :fax_number
          property :first_name
          property :last_name
          property :operational_name
          property :academic_title
          property :gender
          property :responsibility
          property :position
          property :street
          property :zip_and_city
          property :spoc

          property :organization_id
          has_one :organization do
            type :organizations
            property :id
            property :name, as: :label
          end

          property :email_id
          has_one :email do
            type :organizations
            property :id
            property :address, as: :label
          end

          property :label, getter: ->(contact_person) do
            contact_person[:represented].display_name
          end
        end
      end

      class Index < Show
      end
    end
  end
end
