# frozen_string_literal: true
module API::V1
  module Filter
    module Representer
      class Show < API::V1::Default::Representer::Show
        # type :filters
        include Roar::JSON::JSONAPI.resource :filters

        attributes do
          property :label, getter: ->(filter) do
            filter[:represented].identifier
          end

          property :identifier
          property :name
        end
      end

      class Index < Show
      end
    end
  end
end
