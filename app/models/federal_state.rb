# frozen_string_literal: true
# Monkeypatch clarat_base Location
require ClaratBase::Engine.root.join('app', 'models', 'federal_state')
# Normalization of (German) federal states.
class FederalState < ActiveRecord::Base
  # Associations
  has_many :locations, inverse_of: :federal_state

  include ReformedValidationHack
end
