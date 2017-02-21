# frozen_string_literal: true
# Monkeypatch clarat_base ContactPersonTranslation
require ClaratBase::Engine.root.join('app', 'models', 'contact_person_translation')

class ContactPersonTranslation < ActiveRecord::Base
  # # Search
  # include PgSearch
  # pg_search_scope :search_everything,
  #                 against: [
  #                   :id, :contact_people_id, :responsibility, :locale, :source
  #                 ],
  #                 using: { tsearch: { prefix: true } }
end
