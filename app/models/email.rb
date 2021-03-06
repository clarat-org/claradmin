# frozen_string_literal: true

# Monkeypatch clarat_base Email
unless defined?(Email)
  require ClaratBase::Engine.root.join('app', 'models', 'email')
end

class Email < ApplicationRecord
  include ReformedValidationHack

  # Associations
  has_many :offer_mailings, inverse_of: :email
  has_many :known_offers, source: :offer, through: :offer_mailings,
                          inverse_of: :informed_emails

  # Search
  # include PgSearch
  # pg_search_scope :search_pg,
  #                 against: [:id, :address],
  #                 using: {
  #                   tsearch: { only: [:id], prefix: true },
  #                   trigram: { only: [:address], threshold: 0.3 }
  #                 }
  # NOTE Hack: use manual scope with LIKE query for containing search
  scope :search_pg, ->(input) {
    where('address LIKE ?', "%#{input}%").limit(30)
  }

  # State Machine
  aasm do
    event :inform, guard: :informable_offers_or_orga_contact? do
      # First check if email needs to be blocked
      transitions from: :uninformed, to: :blocked, guard: :should_be_blocked?
      # Else send email if there are approved offers
      transitions from: :uninformed, to: :informed, after: :send_mailing!
    end
  end

  # Methods
  def newly_approved_offers_from_offer_context
    offers.visible_in_frontend.by_mailings_enabled_organization
          .select(&:remote_or_belongs_to_informable_city?) - known_offers.all
  end

  # NOTE: for later use
  # orga.first is okay because an orga-contact may
  # only belong to one organization
  # def newly_approved_offers_from_orga_context
  #   organizations.first.offers.visible_in_frontend
  #                .select(&:remote_or_belongs_to_informable_city?) -
  #     known_offers.all
  # end

  def create_offer_mailings offers, mailing_type
    offers.each do |offer|
      OfferMailing.create! offer_id: offer.id, email_id: id,
                           mailing_type: mailing_type
    end
  end

  def send_mailing!
    regenerate_security_code
    if informable_offers? # has higher priority
      OfferMailer.inform_offer_context(self).deliver_now
    elsif belongs_to_unique_orga_with_orga_contact? # lower priority
      OfferMailer.inform_organization_context(self).deliver_now
    else # should not happen
      raise "Mailing requested, but no valid mailing found for Email ##{id}"
    end
  end

  # required for both offer and orga mailer
  def vague_contact_title?
    contact_person = contact_people.first
    contact_people.count > 1 || !contact_person.gender ||
      (!contact_person.last_name? && !contact_person.first_name?)
  end

  # email belongs to at least one orga-contact, has a distinct orga that
  # qualifies for an orga-mailing
  def belongs_to_unique_orga_with_orga_contact?
    contact_people.where.not(position: nil).any? &&
      organizations.uniq.count == 1 && informable_orga?(organizations.first)
  end

  def belongs_to_at_least_one_informable_offer?
    offers.visible_in_frontend.select(
      &:remote_or_belongs_to_informable_city?
    ).any?
  end

  private

  def informable_offers_or_orga_contact?
    informable_offers? || belongs_to_unique_orga_with_orga_contact?
  end

  def informable_offers?
    belongs_to_at_least_one_informable_offer? &&
      organizations.where(mailings: 'enabled').any?
  end

  def informable_orga? orga
    orga.aasm_state == 'all_done' && orga.mailings_enabled? &&
      !orga.offers.visible_in_frontend.select(
        &:remote_or_belongs_to_informable_city?
      ).empty?
  end
end
