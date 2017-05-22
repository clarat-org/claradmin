# Connector Model Offer <-> Filter
class FiltersOffer < ActiveRecord::Base
  # Associtations
  belongs_to :filter, inverse_of: :filters_offers
  belongs_to :offer, inverse_of: :filters_offers

  # Scopes
  default_scope { order(:offer_id) }

  # For rails_admin display
  def name
    "#{filter.name} (#{filter.type})"
  end
end
