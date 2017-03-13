module API::V1
  module OrganizationTranslation
    class Show < Trailblazer::Operation
      include Model
      model ::ContactPersonTranslation, :find

      include Trailblazer::Operation::Representer
      representer API::V1::ContactPersonTranslation::Representer::Show

      def process(*)
      end
    end
  end
end
