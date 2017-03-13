# frozen_string_literal: true
module API::V1
  module ContactPersonTranslation
    class Index < API::V1::Default::Index
      def base_query #what does this do? 
        ::ContactPersonTranslation.where(locale: [:en, :ar, :fa]).uniq
          .joins(:section_filters).where('filters.identifier = ?', 'refugees')
      end

      representer API::V1::ContactPersonTranslation::Representer::Index
    end
  end
end
