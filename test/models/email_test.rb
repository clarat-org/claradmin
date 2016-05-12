# frozen_string_literal: true
require_relative '../test_helper'

describe Email do
  let(:email) { Email.new address: 'a@b.c' }
  subject { email }

  describe 'associations' do
    it { subject.must have_many :offer_mailings }
    it { subject.must have_many(:known_offers).through :offer_mailings }
  end

  describe 'methods' do
    it 'should find all newly approved offers for an email' do
      email = FactoryGirl.create :email, :with_approved_and_unapproved_offer
      email.not_yet_but_soon_known_offers.count.must_equal 1
    end

    describe '#informable_offers?' do
      it 'should be true if it has approved offers & a mailings_enabled orga' do
        email = FactoryGirl.create :email
        offer = FactoryGirl.create :offer, :approved
        offer.contact_people.first.update_column :email_id, email.id
        email.organizations.first.update_column :mailings_enabled, true
        email.send(:informable_offers?).must_equal true
      end

      it 'should be false if it has no approved offers' do
        email = FactoryGirl.create :email
        offer = FactoryGirl.create :offer
        offer.contact_people.first.update_column :email_id, email.id
        email.organizations.first.update_column :mailings_enabled, true
        email.send(:informable_offers?).must_equal false
      end

      it 'should be false if it has no mailings_enabled orga' do
        email = FactoryGirl.create :email
        offer = FactoryGirl.create :offer, :approved
        offer.contact_people.first.update_column :email_id, email.id
        email.organizations.first.update_column :mailings_enabled, false
        email.send(:informable_offers?).must_equal false
      end
    end
  end

  describe 'state machine' do
    describe '#inform' do
      subject { email.inform }

      describe 'when assigned to contact people with approved offers' do
        let(:email) { FactoryGirl.create :email, :with_approved_offer }

        it 'should be possible from uninformed' do
          OfferMailer.expect_chain(:inform_offer_context, :deliver_now)
          subject.must_equal true
          email.must_be :informed?
        end

        it 'wont be possible from informed' do
          email.aasm_state = 'informed'
          assert_raises(AASM::InvalidTransition) { subject }
        end

        it 'wont be possible from subscribed' do
          email.aasm_state = 'subscribed'
          assert_raises(AASM::InvalidTransition) { subject }
        end

        it 'wont be possible from unsubscribed' do
          email.aasm_state = 'unsubscribed'
          assert_raises(AASM::InvalidTransition) { subject }
        end

        it 'wont be possible if no organization is mailings_enabled' do
          email.organizations.update_all mailings_enabled: false
          OfferMailer.expects(:inform_offer_context).never
          assert_raises(AASM::InvalidTransition) { subject }
        end

        it 'should transition to blocked when a contact_person is an SPoC and'\
           ' should not send email' do
          email.contact_people.first.update_column :spoc, true
          OfferMailer.expects(:inform_offer_context).never
          subject
          email.must_be :blocked?
        end

        it 'should send an info email when transitioned' do
          OfferMailer.expect_chain(:inform_offer_context, :deliver_now)
          subject
        end
      end

      describe 'when there are no approved offers' do
        let(:email) { FactoryGirl.create :email, :with_unapproved_offer }

        it 'should be impossible from uninformed and wont send an info mail' do
          OfferMailer.expects(:inform_offer_context).never
          assert_raises(AASM::InvalidTransition) { subject }
        end
      end
    end

    describe '#send_mailings!' do
      it 'should generate a security code' do
        email.expects(:regenerate_security_code)
        email.stubs(:raise)
        email.send_mailing!
      end

      it 'should send an offer context mailing when it has approved offers'\
         ' and is in a mailings_enabled organization' do
        email = FactoryGirl.create :email, :with_approved_offer
        email.organizations.first.update_column :mailings_enabled, true
        OfferMailer.expect_chain(:inform_offer_context, :deliver_now)
        email.send_mailing!
      end

      it 'should send an orga context mailing when it is in an orga contact'\
         ', even when orga is not mailings_enabled has no approved offers' do
        email = FactoryGirl.create :email, :with_unapproved_offer
        email.contact_people.first.update_column :position, 'superior'
        email.organizations.first.update_column :mailings_enabled, false
        OfferMailer.expect_chain(:inform_organization_context, :deliver_now)
        email.send_mailing!
      end

      it 'should raise an error when neither of the above is true' do
        assert_raises(RuntimeError) { email.send_mailing! }
      end

      it 'wont send an offer context mailing when it has approved offers'\
         ' but the orga is not mailings_enabled' do
        email = FactoryGirl.create :email, :with_approved_offer
        email.organizations.first.update_column :mailings_enabled, false
        OfferMailer.expects(:inform_offer_context).never
        assert_raises { email.send_mailing! }
      end

      it 'wont send an offer context mailing when it has no approved offers'\
         ' but the orga is mailings_enabled' do
        email = FactoryGirl.create :email, :with_unapproved_offer
        email.organizations.first.update_column :mailings_enabled, true
        OfferMailer.expects(:inform_offer_context).never
        assert_raises { email.send_mailing! }
      end

      it 'wont send an orga context mailing when it is in a position contact'\
         ' but is in more than one organization' do
        email = FactoryGirl.create :email, :with_unapproved_offer
        email.contact_people.first.update_column :position, 'superior'
        email.contact_people <<
          FactoryGirl.create(:contact_person, position: 'superior')
        OfferMailer.expects(:inform_organization_context).never
        assert_raises { email.send_mailing! }
      end
    end

    # it 'wont send mailing to subscribed emails that have approved offers but'\
    #    ' that were already informed about those offers' do
    #   email = FactoryGirl.create :email, :subscribed, :with_approved_offer
    #   email.create_offer_mailings email.offers.all, :inform
    #   SubscribedEmailMailingWorker.expects(:perform_async).never
    #   worker.perform
    # end

    # describe '#inform_orga' do
    #   subject { email.inform_orga }
    #
    #   describe 'when assigned to contact people with approved offers' do
    #     let(:email) { FactoryGirl.create :email, :with_approved_offer }
    #
    #     it 'should be possible from uninformed' do
    #       email.contact_people.first.update_column :position, 'superior'
    #       OfferMailer.stub_chain(:inform_organization_context, :deliver_now)
    #       subject.must_equal true
    #       email.must_be :informed?
    #     end
    #
    #     it 'wont be possible from informed' do
    #       email.aasm_state = 'informed'
    #       assert_raises(AASM::InvalidTransition) { subject }
    #     end
    #
    #     it 'wont be possible from subscribed' do
    #       email.aasm_state = 'subscribed'
    #       assert_raises(AASM::InvalidTransition) { subject }
    #     end
    #
    #     it 'wont be possible from unsubscribed' do
    #       email.aasm_state = 'unsubscribed'
    #       assert_raises(AASM::InvalidTransition) { subject }
    #     end
    #
    #     it 'wont be possible if no organization is mailings_enabled' do
    #       email.organizations.update_all mailings_enabled: false
    #       OfferMailer.expects(:inform_organization_context).never
    #       assert_raises(AASM::InvalidTransition) { subject }
    #     end
    #
    #     it 'should transition to blocked when a contact_person is an SPoC and'\
    #        ' should not send email' do
    #       email.contact_people.first.update_columns spoc: true, position: 'superior'
    #       OfferMailer.expects(:inform_organization_context).never
    #       subject
    #       email.must_be :blocked?
    #     end
    #
    #     it 'should send an info email when transitioned' do
    #       email.contact_people.first.update_column :position, 'superior'
    #       OfferMailer.expect_chain(:info_organization_contextrm, :deliver_now)
    #       subject
    #     end
    #   end
    #
    #   describe 'when there are no approved offers' do
    #     let(:email) { FactoryGirl.create :email, :with_unapproved_offer }
    #
    #     it 'should be impossible from uninformed and wont send an info mail' do
    #       OfferMailer.expects(:inform_organization_context).never
    #       assert_raises(AASM::InvalidTransition) { subject }
    #     end
    #   end
    # end
  end
end
