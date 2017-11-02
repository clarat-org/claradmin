# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../support/utils/policy_test_utils'

class ApplicationPolicyTest < ActiveSupport::TestCase
  include PolicyTestUtils

  subject { ApplicationPolicy.new(User.first, Assignment.new) }

  it { denies_everything }
end
