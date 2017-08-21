# frozen_string_literal: true

# Monkeypatch clarat_base Category
require ClaratBase::Engine.root.join('app', 'models', 'tag')

class Tag < ApplicationRecord
  after_save :translate_if_name_en_changed
  # Methods

  private

  def translate_if_name_en_changed
    return if !saved_change_to_name_en? && !@new_record_before_save
    GengoCommunicator.new.create_translation_jobs(self, 'name')
  end
end
