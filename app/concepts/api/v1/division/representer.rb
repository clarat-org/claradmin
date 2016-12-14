# frozen_string_literal: true
module API::V1
  module Division
    module Representer
      class Show < API::V1::Default::Representer::Show
        type :divisions

        property :label, getter: ->(division) do
          division[:represented].name
        end

        property :name
        property :description

        has_one :organization do
          type :organizations

          property :id
          property :name
        end
      end

      class Index < Show
      end
    end
  end
end
