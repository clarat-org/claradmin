# frozen_string_literal: true
# Monkeypatch clarat_base FiltersOffer
# NOTE only required for old backend - do this differently in new backend!
require ClaratBase::Engine.root.join('app', 'models', 'target_audience_filters_offer')

class TargetAudienceFiltersOffer < ActiveRecord::Base
  # Enumerization
  extend Enumerize

  enumerize :gender_first_part_of_stamp, in: STAMP_FIRST_PART_GENDERS
  enumerize :gender_second_part_of_stamp, in: STAMP_SECOND_PART_GENDERS
  enumerize :residency_status, in: RESIDENCY_STATUSES

  # Callbacks
  before_save :generate_stamps!

  require_relative '../objects/value/target_audience_filters_offer_stamp.rb'
  def generate_stamps!
    I18n.available_locales.each do |locale|
      self.send(
        "stamp_#{locale}=",
        TargetAudienceFiltersOfferStamp.generate_stamp(
          self, offer.section.identifier, locale
        )
      )
    end
  end

  # For rails_admin display
  def name
    if stamp_de.blank? == false
      stamp_de
    elsif target_audience_filter && offer
      "#{target_audience_filter.name} (Offer##{offer.id})"
    else
      'Leere Verknüpfung'
    end
  end
end
