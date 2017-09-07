# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/utils/contract_test_utils'

class OpeningContractsTest < ActiveSupport::TestCase
  include ContractTestUtils

  describe 'Create' do
    let opening = Opening.create!(name: 'mon 00:00-01:00', day: 'mon',
                                  open: Time.zone.now,
                                  close: Time.zone.now + 1.hour)
    let(:subject_opening) { Opening.new }
    subject { Opening::Contracts::Create.new(subject_opening) }

    describe 'validations' do
      describe 'always' do
        it { must_validate_presence_of :day }
      end

      describe 'when close is set' do
        before { subject_opening.close = Time.zone.now }
        it { must_validate_presence_of :open }
      end

      describe 'when close is not set' do
        it { wont_validate_presence_of :open }
      end

      describe 'unique day' do
        before do
          subject_opening.open = opening.open
          subject_opening.close = opening.close
        end
        it { must_validate_uniqueness_of :day, opening.day }
      end

      describe 'unique day no open/close' do
        let opening_day = Opening.create!(name: 'mon 00:00-01:00', day: 'mon')
        before do
          subject_opening.open = nil
          subject_opening.close = nil
        end
        it { must_validate_uniqueness_of :day, opening_day.day }
      end

      describe 'unique open' do
        before do
          subject_opening.day = opening.day
          subject_opening.close = opening.close
        end
        it { must_validate_uniqueness_of :open, opening.open }
      end

      describe 'unique close' do
        before do
          subject_opening.open = opening.open
          subject_opening.day = opening.day
        end
        it { must_validate_uniqueness_of :close, opening.close }
      end
    end
  end
end
