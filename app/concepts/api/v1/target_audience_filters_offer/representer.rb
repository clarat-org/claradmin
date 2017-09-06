# frozen_string_literal: true
module API::V1
  module TargetAudienceFiltersOffer
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :split_bases

        attributes do
          property :label, getter: ->(split_base) {
            split_base[:represented].stamp_de
          }
          property :residency_status
          property :gender_first_part_of_stamp
          property :gender_second_part_of_stamp
          property :age_from
          property :age_to
          property :age_visible
          property :stamp_de
        end
      end

      class Index < Show
      end

      class Create < Show
      end
    end
  end
end
