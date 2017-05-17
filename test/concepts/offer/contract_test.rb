# frozen_string_literal: true
require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'
# rubocop:disable ClassLength
class OfferContractTest < ActiveSupport::TestCase
  # include JsonapiTestUtils
  include OperationTestUtils
  let(:offer) { Offer::Contracts::Create.new(offers(:basic)) }

  subject { offer }

  describe 'validations' do
    describe 'always' do
      it { subject.must validate_presence_of :name }
      it { subject.must validate_presence_of :description }
      it { subject.must validate_presence_of :encounter }
      it { subject.must validate_presence_of :section_id }

      it 'should fails if code_word is more than 140 characters' do
        subject.code_word = Array.new(141) { rand(36).to_s(36) }.join
        subject.wont_be :valid?
      end

      it 'should ensure that code_word < 141 characters' do
        subject.code_word = Array.new(140) { rand(36).to_s(36) }.join
        subject.must_be :valid?
      end

      it 'should fail when age_from > age_to' do
        subject.validate(age_from: 9, age_to: 1)
        subject.wont_be :valid?
      end

      it 'should ensure that age_from < age_to' do
        subject.validate(age_from: 9, age_to: 10)
        subject.must_be :valid?
      end

      it 'should fails if personal offer has no location' do
        subject.encounter = 'personal'
        subject.location = nil
        subject.wont_be :valid?
      end

      it 'should ensure a personal offer has a location' do
        subject = Offer::Contracts::Create.new(offers(:basic))
        subject.encounter = 'personal'
        subject.location = Location.new
        subject.must_be :valid?
      end

      it 'should fail if a remote offer has both location and an area' do
        subject.encounter = 'hotline'
        subject.location = Location.new
        subject.area = Area.new
        subject.wont_be :valid?
      end

      it 'should fail if a remote offer has location nut no area' do
        subject.encounter = 'hotline'
        subject.location = Location.new
        subject.area = nil
        subject.wont_be :valid?
      end

      it 'should fail if a remote offer has no location nor area' do
        subject.encounter = 'hotline'
        subject.location = nil
        subject.area = nil
        subject.wont_be :valid?
      end

      it 'should ensure a remote offer has no location but an area' do
        subject.encounter = 'hotline'
        subject.location = nil
        subject.area = Area.new
        subject.must_be :valid? # !
      end

      it 'should fail if locations and organizations do not match (personal)' do
        skip
        location = Location.create(organization: Organization.new.id)
        subject.model.location = location
        subject.model.wont_be :valid?
      end

      it 'should ensure locations and organizations match (personal)' do
        subject.model.location = Location.create(organization:
                                                 organizations(:basic))
        subject.model.must_be :valid?
      end

      it 'should ensure all chosen organizations are expired' do
        subject.organizations.update_all aasm_state: 'expired'
        subject.wont_be :valid?
      end

      it 'should ensure all chosen organizations are approved' do
        subject.organizations.update_all aasm_state: 'approved'
        subject.must_be :valid?
      end

      it 'should fail when chosen contact people not SPoC nor belong to orga' do
        cp = FactoryGirl.create :contact_person, spoc: false,
                                                 offers: [subject.model]
        subject.contact_people << cp
        subject.wont_be :valid?
      end

      it 'should ensure chosen contact people are SPoC' do
        cp = FactoryGirl.create :contact_person, spoc: true,
                                                 offers: [subject.model]
        subject.contact_people << cp
        subject.must_be :valid?
      end

      it 'should ensure chosen contact people belong to orga' do
        cp = FactoryGirl.create :contact_person, spoc: false,
                                                 offers: [subject.model],
                                                 organization_id:
                                                 organizations(:basic).id
        subject.contact_people << cp
        subject.must_be :valid?
      end

      it 'should fail when more than 10 next steps are chosen' do
        10.times do |i| # basic offer has one next step
          subject.next_steps << NextStep.create(text_de: i, text_en: i)
        end
        subject.wont_be :valid?
      end

      it 'should succeed when no more than 10 next steps are chosen' do
        9.times do |i|
          subject.next_steps << NextStep.create(text_de: i, text_en: i)
        end
        subject.must_be :valid?
      end

      it 'should validate presence of expiration date' do
        subject.expires_at = nil
        subject.valid?.must_equal false
      end

      it 'should validate if expires_at is in future and starts_at not set' do
        subject.expires_at = Time.zone.now + 1.day
        subject.valid?.must_equal true
      end

      it 'should fail if start_date > expires_at' do
        subject.expires_at = Time.zone.now + 1.day
        subject.starts_at = Time.zone.now + 2.days
        subject.valid?.must_equal false
      end

      it 'should validate start date is before expires_at' do
        subject.expires_at = Time.zone.now + 1.day
        subject.starts_at = Time.zone.now
        subject.valid?.must_equal true
      end

      it 'age_from should be int' do
        subject.age_from = 'abc'
        subject.valid?.must_equal false
      end

      it 'age_from should be < 100' do
        subject.age_from = 100
        subject.valid?.must_equal false
      end

      it 'age_from should be int' do
        subject.age_from = 0.1
        subject.valid?.must_equal false
      end

      it 'age_from should be => 0' do
        subject.age_from = 0
        subject.valid?.must_equal true
      end

      it 'age_to should be int and not string' do
        subject.age_to = 'abc'
        subject.valid?.must_equal false
      end

      it 'age_to should be < 100' do
        subject.age_to = 100
        subject.valid?.must_equal false
      end

      it 'age_to should be > 0' do
        subject.age_to = 0
        subject.valid?.must_equal false
      end

      it 'age_to should be int and not float' do
        subject.age_to = 0.1
        subject.valid?.must_equal false
      end

      it 'age_to should be > 0' do
        subject.age_to = 1
        subject.valid?.must_equal true
      end

      it 'should validate that section filters of offer and categories match' do
        skip
        subject = offers(:basic)
        category = FactoryGirl.create(:category)
        category.sections = [sections(:family)]
        subject.categories = [category]
        subject.section = sections(:refugees)
        subject.valid?.must_equal false

        subject.section = sections(:family)
        category.sections = [sections(:refugees)]
        subject.valid?.must_equal false

        category.sections =
          [sections(:refugees), sections(:family)]
        subject.valid?.must_equal true
        subject.errors.messages[:categories].must_be :nil?

        subject.section = sections(:refugees)
        category2 = FactoryGirl.create(:category)
        category2.sections = [sections(:family)]
        subject.categories << category2
        subject.valid?.must_equal false

        subject.section = sections(:family)
        subject.valid?.must_equal true

        category.sections = [sections(:refugees)]
        subject.valid?.must_equal false

        # subject.section = [sections(:family), sections(:refugees)]
        # subject.valid?.must_equal true
      end

      it 'should fail when version < 7' do
        subject.logic_version = LogicVersion.create(name: 'chunky', version: 6)
        subject.split_base_id = nil
        subject.valid?
        subject.errors.messages[:split_base].must_be :nil?
      end

      it 'should fail when split_base is nil with version >= 7' do
        subject.logic_version = LogicVersion.create(name: 'bacon', version: 7)
        subject.split_base_id = nil
        subject.valid?
        subject.errors.messages[:split_base].wont_be :nil?
      end

      it 'should validate that split_base is assigned with version >= 7' do
        subject.logic_version = LogicVersion.create(name: 'bacon', version: 7)
        subject.split_base_id = 1
        subject.valid?
        subject.errors.messages[:split_base].must_be :nil?
      end

      # it 'should ensure chosen contact people belong to a chosen orga' do
      #   subject.reload.wont_be :valid?
      #   subject.reload.must_be :valid?
      # end
    end
  end
end
# rubocop:enable ClassLength
