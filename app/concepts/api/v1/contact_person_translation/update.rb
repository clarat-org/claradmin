# frozen_string_literal: true
module API::V1
  module ContactPersonTranslation
    class Update < Trailblazer::Operation
      include Trailblazer::Operation::Representer, Responder
      representer Representer::Show

      include Model
      model ::ContactPersonTranslation, :update

      contract do
        property :responsibility
        property :source
        property :possibly_outdated
      end

      def process(params)
        validate(params[:json]) do |form_object|
          #TODO: this might not be needed
          form_object.source = 'researcher'
          form_object.possibly_outdated = false
          form_object.save
        end
      end
    end
  end
end
