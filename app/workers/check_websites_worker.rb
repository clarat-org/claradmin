# frozen_string_literal: true
class CheckWebsitesWorker
  include Sidekiq::Worker

  sidekiq_options queue: :heavy_load

  def perform
    # Get websites to check (those with approved offers or organizations)
    Website.find_each do |website|
      next unless website.offers_to_be_checked_by_crawler.any? ||
                  website.organizations.approved.any?
      CheckSingleWebsiteWorker.perform_async website.id
    end
  end
end
