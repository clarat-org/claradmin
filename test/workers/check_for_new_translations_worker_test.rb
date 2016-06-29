# frozen_string_literal: true
require_relative '../test_helper'

class CheckForNewTranslationsWorkerTest < ActiveSupport::TestCase
  let(:worker) { CheckForNewTranslationsWorker.new }

  it 'should spawn for every existing (pending) GengoOrder' do
    GengoOrder.create order_id: 23, expected_slug: 'Category:1:name'
    GengoOrder.create order_id: 43, expected_slug: 'Category:2:name'
    GetAndApplyNewTranslationWorker.expects(:perform_async).with(23)
    GetAndApplyNewTranslationWorker.expects(:perform_async).with(43)
    worker.perform
  end
end
