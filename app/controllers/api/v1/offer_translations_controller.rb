# frozen_string_literal: true
module API::V1
  class OfferTranslationsController < ApplicationController
    skip_before_action :authenticate_user!
    respond_to :json

    def index
      respond API::V1::OfferTranslation::Index
    end
  end
end
