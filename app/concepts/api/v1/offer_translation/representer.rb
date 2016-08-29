# frozen_string_literal: true
module API::V1
  module OfferTranslation
    module Representer
      class Show < API::V1::Default::Representer::Show
        type :offer_translations

        property :label, getter: ->(ot) do
          "##{ot[:represented].id} (#{ot[:represented].locale})"
        end
        property :offer_id
        property :locale
        property :source
        property :name
        property :description
        property :possibly_outdated
        property :created_at
        property :updated_at

        # has_one :offer do
        #   property :id
        #   has_many :section_filters do
        #     property :id
        #     property :identifier
        #   end
        # end
        # property :offer_section, getter: ->(ot) do
        #   ot[:represented].offer.section_filters.pluck(:identifier)
        # end
      end

      class Index < Show
        link :self, toplevel: true do
          '//offer_translations'
          # bowl_url(opts[:bowl], :page => current_page)
        end
      end
    end
  end
end
