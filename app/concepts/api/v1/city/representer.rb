# frozen_string_literal: true
module API::V1
  module City
    module Representer
      class Show < API::V1::Default::Representer::Show
        type :cities

        property :name
        property :label, getter: ->(city) {
          city[:represented].name
        }
        property :created_at
        property :updated_at
      end

      class Index < Show
      end
    end
  end
end
