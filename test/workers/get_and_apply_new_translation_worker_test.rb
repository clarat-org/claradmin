# frozen_string_literal: true
require_relative '../test_helper'

class GetAndApplyNewTranslationWorkerTest < ActiveSupport::TestCase
  let(:worker) { GetAndApplyNewTranslationWorker.new }

  it 'should fetch from the GengoCommunicator and apply the changes' do
    GengoOrder.create order_id: 123, expected_slug: 'Category:1:name'
    GengoCommunicator.any_instance.expects(:fetch_order).with(123).returns(
      'total_jobs' => '2', 'jobs_approved' => ['1', '2']
    )
    GengoCommunicator.any_instance.expects(:fetch_job).with(1).returns(
      'body_tgt' => 'fr(GET READY FOR CANADA)', 'slug' => 'Category:1:name_fr',
      'lc_tgt' => 'fr'
    )
    GengoCommunicator.any_instance.expects(:fetch_job).with(2).returns(
      'body_tgt' => 'ar(GET READY FOR CANADA)', 'slug' => 'Category:1:name_fr',
      'lc_tgt' => 'ar'
    )
    Category.find(1).name_fr.wont_equal 'fr(GET READY FOR CANADA)'
    Category.find(1).name_ar.wont_equal 'ar(GET READY FOR CANADA)'
    worker.perform 123
    Category.find(1).name_fr.must_equal 'fr(GET READY FOR CANADA)'
    Category.find(1).name_ar.must_equal 'ar(GET READY FOR CANADA)'
    GengoOrder.find(123).must_equal nil
  end

  # it 'should fetch from the GengoCommunicator and ignore unapproved jobs' do
  #   Category.find(1).update_columns job_id_fr: 123
  #   GengoCommunicator.any_instance.expects(:fetch_job).with(123).returns(
  #     'body_tgt' => 'GET READY FOR CANADA', 'slug' => 'Category:1:name_fr',
  #     'status' => 'translating', 'lc_tgt' => 'fr'
  #   )
  #   Category.find(1).name_fr.wont_equal 'GET READY FOR CANADA'
  #   worker.perform 123
  #   Category.find(1).name_fr.wont_equal 'GET READY FOR CANADA'
  #   Category.find(1).job_id_fr.must_equal 123
  # end
end
