# frozen_string_literal: true
class TimeAllocation::ReportActual < Trailblazer::Operation
  private
  include Trailblazer::Operation::Policy
  policy TimeAllocationPolicy, :report_actual?

  contract do
    property :actual_wa_hours
    validates :actual_wa_hours, presence: true, numericality: true
  end

  def model!(params)
    TimeAllocation::DynamicFind.new(*essential_parameters)
      .find_or_initialize
  end

  def process(params)
    if validate(params[:time_allocation], model)
      contract.save
      side_effects!
    else
      raise 'TimeAllocation report has errors, which should not happen with our'\
            " user base: #{contract.errors.full_messages}"
    end
  end

  def side_effects!
    Statistic::WeeklyStatisticAggregator.new(*essential_parameters).record!
  end

  def essential_parameters
    [@params[:current_user].id, @params[:year], @params[:week_number]]
  end
end
