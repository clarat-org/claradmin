# frozen_string_literal: true
module API::V1
  module City
    module Representer
      class Show < API::V1::Default::Representer::Show
        include Roar::JSON::JSONAPI.resource :cities

        attributes do
          property :name
          property :label, getter: ->(city) {
            city[:represented].name
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
