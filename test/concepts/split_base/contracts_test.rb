# frozen_string_literal: true
require_relative '../../test_helper'
require_relative '../../support/utils/contract_test_utils'

class SplitBaseContractsTest < ActiveSupport::TestCase
  include ContractTestUtils

  describe 'Create' do
    let sub_sb = SplitBase.new
    let solution_category = SolutionCategory.create!(name: 'name')
    subject { SplitBase::Contracts::Create.new(sub_sb) }

    describe 'validations' do
      describe 'always' do
        it { must_validate_presence_of :title }
        it { must_validate_presence_of :solution_category }
      end

      it 'uniqueness if divison same' do
        split_base = SplitBase.create!(clarat_addition: 'addition',
                                       title: 'title',
                                       solution_category: solution_category)
        sub_sb.title = split_base.title
        sub_sb.solution_category = split_base.solution_category
        sub_sb.clarat_addition = split_base.clarat_addition
        sub_sb.divisions = split_base.divisions
        sb_contract = SplitBase::Contracts::Create.new(sub_sb)
        sb_contract.valid?
        sb_contract.errors.messages[:title].must_include I18n.t('errors.messages.taken')
      end

      it 'no uniqueness if divison different' do
        split_base = SplitBase.create!(clarat_addition: 'addition',
                                       title: 'title',
                                       solution_category: solution_category)
        sub_sb.title = split_base.title
        sub_sb.solution_category = split_base.solution_category
        sub_sb.clarat_addition = split_base.clarat_addition
        sub_sb.divisions = [FactoryGirl.create(:division)]
        sb_contract = SplitBase::Contracts::Create.new(sub_sb)
        sb_contract.valid?
        assert_nil sb_contract.errors.messages[:title]
      end

      it 'fails if code_word is more than 140 characters' do
        subject.code_word = Array.new(141) { rand(36).to_s(36) }.join
        subject.wont_be :valid?
      end

      it 'should ensure that code_word < 141 characters' do
        subject.code_word = Array.new(140) { rand(36).to_s(36) }.join
        subject.must_be :valid?
      end
    end
  end
end
