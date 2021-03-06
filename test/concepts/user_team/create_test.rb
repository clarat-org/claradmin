# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'
# require_relative '../../support/utils/jsonapi_test_utils'

class UserTeamCreateTest < ActiveSupport::TestCase
  # include JsonapiTestUtils
  include OperationTestUtils

  let(:user) { users(:super) }
  let(:basic_params) do
    {
      name: 'UserTeamName',
      users: [User.first]
    }
  end

  describe '::UserTeam::Create' do
    it 'must create a UserTeam given valid data' do
      operation_must_work ::UserTeam::Create, basic_params
    end

    describe 'validations' do
      it 'must validate name' do
        basic_params[:name] = nil
        operation_wont_work ::UserTeam::Create, basic_params
      end

      it 'must validate users' do
        basic_params[:users] = nil
        operation_wont_work ::UserTeam::Create, basic_params
        basic_params[:users] = []
        operation_wont_work ::UserTeam::Create, basic_params
        basic_params[:users] = User.first(2)
        operation_must_work ::UserTeam::Create, basic_params
      end
    end
  end
end
