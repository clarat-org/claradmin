# frozen_string_literal: true
module API::V1
  module OfferTranslation
    # class Index < API::V1::Default::Index
    class Index < API::V1::Default::Index
      def base_query
        ::OfferTranslation.where(locale: [:ar, :en])
      end

      representer API::V1::OfferTranslation::Representer::Index
    end
  end
end
