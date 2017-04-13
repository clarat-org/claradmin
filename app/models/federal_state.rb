# frozen_string_literal: true
# Normalization of (German) federal states.
class FederalState < ActiveRecord::Base
  # Associations
  has_many :locations, inverse_of: :federal_state

  include ReformedValidationHack
end
