# frozen_string_literal: true
class AsanaCommunicator < NetCommunicator
  def initialize
    super 'https://app.asana.com'
    @token = Rails.application.secrets.asana_token
  end

  def create_expire_task offer
    organization_names = offer.organizations.pluck(:name).join(',')
    section_names = offer.section_filters.pluck(:identifier).map { |f| f.first(3) }
                         .join(',')
    create_task "#{organization_names} - #{offer.expires_at} - #{section_names}"\
                " - #{offer.name}",
                'Expired: http://claradmin.herokuapp.com/admin/offer/'\
                "#{offer.id}/edit"
  end

  def create_website_unreachable_task_offer website, offer
    orgas = offer.organizations.pluck(:name).join(',')
    create_task "[URL unreachable]#{orgas}-#{offer.expires_at}-#{offer.name}",
                'Expired: http://claradmin.herokuapp.com/admin/offer/'\
                "#{offer.id}/edit | Unreachable website: #{website.url}"
  end

  def create_website_unreachable_task_orgas website
    organization_names = website.organizations.approved.pluck(:name).join(',')
    create_task "[URL unreachable]#{organization_names}",
                "Unreachable website: #{website.url}"
  end

  protected

  def modify_request request
    request['Authorization'] = "Bearer #{@token}"
    request
  end

  private

  def create_task title, content
    post_to_api(
      '/api/1.0/tasks',
      projects: %w(44856824806357), workspace: '41140436022602',
      name: title, notes: content
    )
  end
end
