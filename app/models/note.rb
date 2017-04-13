# frozen_string_literal: true
# Monkeypatch clarat_base NextStep
require ClaratBase::Engine.root.join('app', 'models', 'note')
# Comment for internal use by admins.
# Allows adding note to any other Model. Displayed in Admin backend.
class Note < ActiveRecord::Base
  # Concerns
  include NoteReferencable # A note can be the target of references

  include ReformedValidationHack

  # Associations
  belongs_to :notable, polymorphic: true # , inverse_of: :notes

  belongs_to :referencable, polymorphic: true, inverse_of: :referencing_notes
  belongs_to :user, inverse_of: :authored_notes # Author
end
