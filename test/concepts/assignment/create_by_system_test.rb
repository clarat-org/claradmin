# frozen_string_literal: true
require_relative '../../test_helper'

class AssignmentCreateBySystemTest < ActiveSupport::TestCase
  let(:user) { users(:researcher) }
  let(:basic_options) do
    { assignable: offer_translations(:en), last_acting_user: user }
  end

  it 'must create an assignment with inferred data' do
    result = ::Assignment::CreateBySystem.({}, basic_options)
    result.must_be :success?
    result['model'].must_be :persisted?
  end

  it 'must create the a system-assignment for a family-offer-translation' do
    result = ::Assignment::CreateBySystem.({}, basic_options)
    result.must_be :success?
    assignment = result['model']
    assignment.must_be :persisted?
    assignment.receiver_id.must_equal User.system_user.id
    assert_nil assignment.receiver_team_id
    assignment.creator_id.must_equal User.system_user.id
    assert_nil assignment.creator_team_id
    assignment.message.must_equal 'Managed by system'
  end

  # NOTE: more tests not really required because the logic is indirectly tested
  # by automatic_upsert_test
end
