# frozen_string_literal: true
require_relative '../../../test_helper'
require_relative '../../../support/utils/operation_test_utils'
# require_relative '../../support/utils/jsonapi_test_utils'

class StatisticChartIndexTest < ActiveSupport::TestCase
  # include JsonapiTestUtils
  include OperationTestUtils

  let(:user) { users(:researcher) }

  describe '::StatisticChart::Index' do
    it 'base_query must be ::StatisticChart per default' do
      ::API::V1::StatisticChart::Index.new.base_query.must_equal
        ::StatisticChart
    end
  end
end
