# frozen_string_literal: true
require 'httparty'

class CheckSingleWebsiteWorker
  include Sidekiq::Worker

  sidekiq_options queue: :heavy_load

  def perform website_id
    website = Website.find(website_id)
    if check_website_unreachable? website
      # expire if it was unreachable (a week) before
      expire_and_create_asana_tasks website if website.unreachable?
      # always flip unreachable boolean
      website.update_columns unreachable: !website.unreachable
    else
      # reset yellow card when website was reachable this time
      website.update_columns unreachable: false
    end
  end

  private

  def expire_and_create_asana_tasks website
    asana = AsanaCommunicator.new
    # Create Asana Tasks, set state to expired and manually reindex for algolia
    website.offers_to_be_checked_by_crawler.each do |expiring_offer|
      asana.create_website_unreachable_task_offer website, expiring_offer
      expiring_offer.update_columns(aasm_state: 'website_unreachable')
      expiring_offer.index!
    end
    # no approved offers but approved organizations => create different task
    # for all organizations and don't change anything
    if website.offers.approved.empty? && !website.organizations.approved.empty?
      asana.create_website_unreachable_task_orgas website
    end
  end

  def check_website_unreachable? website
    # get website and check for error codes
    response = HTTParty.get(website.url)
    if !response || response.code >= 400 # everything above 400 is an error
      return true
    end
    return false
  # catch errors that prevent a valid response
  rescue HTTParty::RedirectionTooDeep, Errno::EHOSTUNREACH, SocketError,
         Timeout::Error, URI::InvalidURIError, OpenSSL::SSL::SSLError,
         Net::ERR_CERT_AUTHORITY_INVALID
    return true
  end
end
