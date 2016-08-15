# frozen_string_literal: true
require_relative '../test_helper'

class CheckWebsitesWorkerTest < ActiveSupport::TestCase # to have fixtures
  let(:spawner_worker) { CheckWebsitesWorker.new }
  let(:single_worker) { CheckSingleWebsiteWorker.new }

  it 'should create asana task, expire and index offer with 404 website' do
    website = FactoryGirl.create :website, :own
    offer = FactoryGirl.create :offer, :approved
    offer.section_filters = [SectionFilter.find_by(identifier: 'refugees') ||
      FactoryGirl.create(:section_filter, identifier: 'refugees', name: 'Refugees')]
    website.offers << offer
    Offer.any_instance.expects(:index!)
    AsanaCommunicator.any_instance.expects(:create_website_unreachable_task_offer)
    WebMock.stub_request(:get, 'www.example.com')
           .to_return(status: 404, body: '', headers: {}) # 404 stub
    # first time: offer stays approved but unreachable is set to true
    single_worker.perform website.id
    offer.reload.must_be :approved?
    website.reload.unreachable.must_equal true
    # second time: offer is expired and unreachable reset to false
    single_worker.perform website.id
    offer.reload.must_be :website_unreachable?
    website.reload.unreachable.must_equal false
  end

  it 'should create asana task, expire and index offer with timeout '\
     'website' do
    website = FactoryGirl.create :website, :own, unreachable: true
    offer = FactoryGirl.create :offer, :approved
    offer.section_filters = [SectionFilter.find_by(identifier: 'refugees') ||
      FactoryGirl.create(:section_filter, identifier: 'refugees', name: 'Refugees')]
    website.offers << offer
    Offer.any_instance.expects(:index!)
    AsanaCommunicator.any_instance.expects(:create_website_unreachable_task_offer)
    WebMock.stub_request(:get, 'www.example.com').to_timeout
    single_worker.perform website.id
    offer.reload.must_be :website_unreachable?
    website.reload.unreachable.must_equal false
  end

  it 'should ignore offers with reachable website and reset unreachable flag' do
    website = FactoryGirl.create :website, :own, unreachable: true
    offer = FactoryGirl.create :offer, :approved
    website.offers << offer
    Offer.any_instance.expects(:index!).never
    AsanaCommunicator.any_instance.expects(:create_website_unreachable_task_offer).never
    WebMock.stub_request(:get, 'www.example.com') # stub request to return success
    single_worker.perform website.id
    offer.reload.must_be :approved?
    website.reload.unreachable.must_equal false
  end

  it 'should create AsanaTask for orga with 404 website and not change state' do
    website = FactoryGirl.create :website, :own, unreachable: true
    orga = FactoryGirl.create :organization, :approved, name: 'bazfuz'
    website.organizations << orga
    AsanaCommunicator.any_instance.expects(:create_website_unreachable_task_offer).never
    AsanaCommunicator.any_instance.expects(:create_website_unreachable_task_orgas)
    WebMock.stub_request(:get, 'www.example.com')
           .to_return(status: 404, body: '', headers: {}) # 404 stub
    single_worker.perform website.id
    orga.must_be :approved?
  end

  it 'should correctly spawn single workers' do
    website = FactoryGirl.create :website, :own
    offer = FactoryGirl.create :offer, :approved
    offer.section_filters = [SectionFilter.find_by(identifier: 'refugees') ||
      FactoryGirl.create(:section_filter, identifier: 'refugees', name: 'Refugees')]
    # remove faked random websites to ensure single invocation of perform_async
    Website.find_each do |faked_website|
      faked_website.offers = []
      faked_website.organizations = []
    end
    website.offers << offer
    CheckSingleWebsiteWorker.expects(:perform_async).with(website.id).once
    spawner_worker.perform
  end
end
