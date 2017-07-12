# frozen_string_literal: true
require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'
# require_relative '../../support/utils/jsonapi_test_utils'

class UserTeamUpdateTest < ActiveSupport::TestCase
  # include JsonapiTestUtils
  include OperationTestUtils

  let(:user) { users(:super) }
  let(:basic_params) do
    { id: 1, name: 'UserTeamName', user_ids: [1] }
  end
  let(:spec_attrs) do
    {
      model: 'SomeModel', field_name: 'SomeField',
      field_start_value: 'SomeStart', field_end_value: 'SomeEnd'
    }
  end

  describe '::UserTeam::Update' do
    it 'must create a UserTeam given valid data' do
      operation_must_work ::UserTeam::Update, basic_params
    end

    it 'should correctly update team statistics on user teamchange' do
      Statistic.where(trackable_type: 'UserTeam').count.must_equal 0

      UserTeam.find(1).users = User.where(id: [1, 2])
      Statistic.create!(spec_attrs.merge(date: Date.current, trackable_id: 1, trackable_type: 'User', count: 1))
      Statistic.create!(spec_attrs.merge(date: Date.current, trackable_id: 2, trackable_type: 'User', count: 3))

      Statistic::DailyTeamStatisticSynchronizer.new(1, Date.current.year).record!
      team_statistics = Statistic.where(trackable_type: 'UserTeam')
      team_statistics.count.must_equal 1
      team_statistics.first.count.must_equal 4.0
      operation_must_work ::UserTeam::Update, id: 1, name: 'UserTeamName', user_ids: [1, 2]
      team_statistics.first.count.must_equal 4.0
      operation_must_work ::UserTeam::Update, id: 1, name: 'UserTeamName', user_ids: [1]
      team_statistics.first.reload
      team_statistics.first.count.must_equal 1.0
    end

    describe 'validations' do
      it 'must validate name' do
        basic_params[:name] = nil
        operation_wont_work ::UserTeam::Update, basic_params
      end

      it 'must validate user_ids' do
        basic_params[:user_ids] = nil
        operation_wont_work ::UserTeam::Update, basic_params
        basic_params[:user_ids] = []
        operation_wont_work ::UserTeam::Update, basic_params
        basic_params[:user_ids] = [1, 2]
        operation_must_work ::UserTeam::Update, basic_params
      end
    end
  end
end
