# frozen_string_literal: true
class TimeAllocationsController < BackendController
  def index
    @props = {
      users: User.where(role: 'researcher').all,
      start_year: User.order('created_at ASC').first.created_at.year,
      time_allocations: TimeAllocation.all,
      authenticity_token: form_authenticity_token
    }
  end

  def create
    run TimeAllocation::CRUD
    redirect_to :time_allocations
  end

  def update
    run TimeAllocation::CRUD
    redirect_to :time_allocations
  end
end
