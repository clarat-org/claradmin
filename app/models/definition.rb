# frozen_string_literal: true
# Monkeypatch clarat_base Definition
require ClaratBase::Engine.root.join('app', 'models', 'definition')
class Definition < ApplicationRecord
  include ReformedValidationHack
end
