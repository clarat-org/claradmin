# frozen_string_literal: true
# Monkeypatch clarat_base ContactPersonTranslation
require ClaratBase::Engine.root.join('app', 'models', 'contact_person_translation')

class ContactPersonTranslation < ActiveRecord::Base
end
