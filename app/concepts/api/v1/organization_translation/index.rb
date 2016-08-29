# frozen_string_literal: true
module API::V1
  module OrganizationTranslation
    class Index < API::V1::Default::Index
      def model!(params)
        query = ::OrganizationTranslation.where(locale: [:ar, :ru, :en])
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
        query.paginate(page: params[:page])
      end

      representer API::V1::OrganizationTranslation::Representer::Index
    end
  end
end
