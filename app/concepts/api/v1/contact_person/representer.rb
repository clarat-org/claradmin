# frozen_string_literal: true
module API::V1
  module ContactPerson
    module Representer
      class Show < API::V1::Default::Representer::Show
        type :contact_people

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

        property :email_id

        property :label, getter: ->(solution_category) do
          solution_category[:represented].display_name
        end
      end

      class Index < API::V1::Default::Representer::Index
      end
    end
  end
end