# frozen_string_literal: true

require_relative '../../test_helper'

class API::V1::Assignable::RepresenterTest < ActiveSupport::TestCase
  # use OfferTranslation for simple assignable representer tests
  let(:subject) { API::V1::OfferTranslation::Representer::Show }

  it 'should provide the current_assignment and the assignments collection' do
    record = OfferTranslation.find(1)
    result = subject.new(record).to_hash
    result['data']['id'].must_equal '1'
    result['data']['attributes']['current-assignment-id'].must_equal(
      Assignment.first.id
    )
    result['data']['relationships']['assignments'].length.must_equal 1
  end
end
