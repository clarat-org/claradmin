# frozen_string_literal: true

require 'ffaker'

FactoryGirl.define do
  factory :offer do
    # required fields
    name { FFaker::Lorem.words(rand(3..5)).join(' ').titleize }
    description { FFaker::Lorem.paragraph(rand(4..6))[0..399] }
    old_next_steps { FFaker::Lorem.paragraph(rand(1..3))[0..399] }
    encounter do
      # weighted
      %w[personal personal personal personal hotline
         chat forum email online-course portal].sample
    end
    area { Area.first unless encounter == 'personal' }
    next_steps { [NextStep.first || FactoryGirl.create(:next_step)] }
    solution_category do
      SolutionCategory.all.sample ||
        FactoryGirl.create(:solution_category)
    end
    approved_at nil
    # every offer should have a creator!
    created_by { User.all.sample.id || FactoryGirl.create(:researcher).id }

    # associations
    transient do
      website_count { rand(0..3) }
      language_count { rand(1..2) }
      audience_count 1
      opening_count { rand(1..5) }
      fake_address false
      section nil
      organizations nil
      divisions nil
    end

    after :build do |offer, evaluator|
      # SplitBase => Division(s) => Organization(s)
      organizations = evaluator.organizations ||
                      [FactoryGirl.create(:organization, :approved)]
      organization = organizations.first
      div = organization.divisions.first ||
            FactoryGirl.create(:division, organization: organization)
      offer.divisions << div

      # location
      if offer.personal?
        location = organization.locations.sample ||
                   if evaluator.fake_address
                     FactoryGirl.create(:location, :fake_address,
                                        organization: organization)
                   else
                     FactoryGirl.create(:location, organization: organization)
                   end
        offer.location = location
      end

      # Filters
      if evaluator.section
        offer.section = Section.find_by(identifier: evaluator.section)
      else
        offer.section_id = offer.divisions.first.section_id
      end

      evaluator.language_count.times do
        offer.language_filters << (
          LanguageFilter.all.sample ||
            FactoryGirl.create(:language_filter)
        )
      end
    end

    after :create do |offer, evaluator|
      # Contact People
      offer.organizations.count.times do
        offer.contact_people << FactoryGirl.create(
          :contact_person, organization: offer.organizations.first
        )
      end

      # ...
      create_list :hyperlink, evaluator.website_count, linkable: offer
      evaluator.opening_count.times do
        offer.openings << (
          if Opening.count != 0 && rand(2).zero?
            Opening.select(:id).all.sample
          else
            FactoryGirl.create(:opening)
          end
        )
      end
      evaluator.audience_count.times do
        offer.target_audience_filters << (
          TargetAudienceFilter.all.sample ||
            FactoryGirl.create(:target_audience_filter)
        )
      end
    end

    trait :approved do
      after :create do |offer, _evaluator|
        Offer.where(id: offer.id).update_all aasm_state: 'approved',
                                             approved_at: Time.zone.now
        offer.reload
      end
      approved_by { FactoryGirl.create(:researcher).id }
    end

    trait :with_email do
      after :create do |offer, _evaluator|
        offer.contact_people.first.update_column(
          :email_id, FactoryGirl.create(:email).id
        )
      end
    end

    trait :with_location do
      encounter 'personal'
    end

    # trait :remote do
    #   encounter %w(hotline chat forum email online-course portal).sample
    # end

    trait :with_dummy_translations do
      after :create do |offer, _evaluator|
        (I18n.available_locales - [:de]).each do |locale|
          FactoryGirl.create(
            :offer_translation,
            offer: offer,
            locale: locale,
            source: 'GoogleTranslate',
            name: "#{locale}(#{offer.name})",
            description: "#{locale}(#{offer.description})",
            old_next_steps: "GET READY FOR CANADA! (#{locale})",
            opening_specification: offer.opening_specification ? locale : nil
          )

          offer.organizations.each do |organization|
            FactoryGirl.create(
              :organization_translation,
              organization: organization,
              locale: locale,
              source: 'GoogleTranslate',
              description: "#{locale}(#{organization.description})"
            )
          end
        end
      end
    end
  end
end

def maybe result
  rand(2).zero? ? nil : result
end
