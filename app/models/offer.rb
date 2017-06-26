# frozen_string_literal: true
# Monkeypatch clarat_base Offer
require ClaratBase::Engine.root.join('app', 'models', 'offer')

class Offer < ActiveRecord::Base
  has_paper_trail

  EDITABLE_IN_STATES =
    %(initialized approved expired checkup_process approval_process edit)

  # Modules
  include SearchAlgolia, StateMachine

  # Concerns
  include Translations, RailsAdminParamHack

  # Search
  include PgSearch
  pg_search_scope :search_by_tester, against: [:name, :description,
                                               :aasm_state],
                                     using: { tsearch: { prefix: true } }

  pg_search_scope :search_everything,
                  # TODO: we might have to limit this for performance
                  # against: attribute_names.map(&:to_sym),
                  against: [
                    :name, :description, :aasm_state, :encounter,
                    :old_next_steps, :code_word
                  ],
                  associated_against: {
                    section: :name,
                    organizations: :name,
                    location: :display_name,
                    categories: :name_de,
                    solution_category: :name,
                    target_audience_filters: :name,
                    trait_filters: :name,
                    logic_version: :name
                  },
                  using: { tsearch: { prefix: true } }

  # TODO? This works in console but raises ArgumentError otherwise...
  # pg_search_scope :search_dynamic, (lambda do |name_part, query|
  #   raise ArgumentError unless respond_to?(name_part)
  #   {
  #     against: name_part,
  #     query: query,
  #     using: { tsearch: { prefix: true } }
  #   }
  # end)

  # Associations
  has_many :offer_mailings, inverse_of: :offer
  has_many :informed_emails, source: :email, through: :offer_mailings,
                             inverse_of: :known_offers

  # Scopes
  scope :seasonal, -> { where.not(starts_at: nil) }
  scope :by_mailings_enabled_organization, lambda {
    joins(:organizations).where('organizations.mailings = ?', 'enabled')
  }

  # Admin specific methods
  delegate :identifier, to: :section, prefix: true

  validate :validate_solution_category

  def validate_solution_category
    unless self.solution_category == self.split_base.solution_category
      fail_validation :solution_category, 'solution category is not correct'
    end
  end

  # Customize duplication.
  # Lots of configs here, so we are OK with a longer method:
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def partial_dup
    self.dup.tap do |offer|
      offer.created_by = nil
      offer.expires_at = Time.zone.now + 1.year
      offer.location = self.location
      offer.organizations = self.organizations
      offer.openings = self.openings
      offer.categories = self.categories
      offer.section = self.section
      offer.language_filters = self.language_filters
      offer.trait_filters = self.trait_filters
      offer.websites = self.websites
      offer.contact_people = self.contact_people
      offer.tags = self.tags
      offer.next_steps = self.next_steps
      offer.area = self.area
      offer.aasm_state = 'initialized'
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  # we only want to inform the outside world about offers that are either remote
  # offers or belong to a city with a certain number of approved offers and
  # organizations
  def remote_or_belongs_to_informable_city?
    # search a city by area (remote offers that are limited to a certain area)
    city_by_area_name = area ? City.find_by(name: area.name) : nil
    direct_or_indirect_city = location ? location.city : city_by_area_name
    direct_or_indirect_city.nil? || direct_or_indirect_city.thresholds_reached?
  end

  def editable?
    EDITABLE_IN_STATES.include?(aasm_state)
  end
end
