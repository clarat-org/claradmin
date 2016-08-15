# frozen_string_literal: true
# Monkeypatch clarat_base Website
require ClaratBase::Engine.root.join('app', 'models', 'website')

class Website < ActiveRecord::Base
  # Methods
  # currently, only refugees-offers or family-offers with newest version should
  # be checked
  def offers_to_be_checked_by_crawler
    (offers.approved.in_section('family').where('logic_version_id >= ? ', 8) +
      offers.approved.in_section('refugees')).uniq
  end
end
