# frozen_string_literal: true
module API::V1
  module OfferTranslation
    class Index < API::V1::Default::Index
      def model!(params)
        query = ::OfferTranslation.where(locale: [:ar, :ru, :en])
        if params[:query] && !params[:query].empty?
          query = query.search_everything(params[:query])
        end
        if params[:sort]
          query = query.order(params[:sort] => params[:direction] || 'DESC')
        end
        if params[:filter]
          params[:filter].each do |filter, value|
            next if value.empty?
            query = query.where(filter => value)
          end
        end
        query
      end

      representer API::V1::OfferTranslation::Representer::Index
    end
  end
end
