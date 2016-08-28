# frozen_string_literal: true
class ReactCell < Cell::ViewModel
  def show
    render
  end

  private

  include ReactOnRailsHelper

  def props
    {
      user_teams: UserTeam.all,
      users: User.all.map { |user| UserRepresenter.new(user) },
      current_user: UserRepresenter.new(options[:current_user]),

      productivity_goals: ProductivityGoal.all,
      statistics: Statistic.all,
      time_allocations: TimeAllocation.all,

      start_year: User.order('created_at ASC').first.created_at.year,
      authToken: options[:form_authenticity_token]
    }
  end
end
