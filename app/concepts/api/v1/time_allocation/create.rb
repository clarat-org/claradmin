# frozen_string_literal: true
class TimeAllocation::Create < Trailblazer::Operation
  def contract!(model=nil, _contract_class=nil)
    @_contract ||=
      if model.new_record?
        TimeAllocation::Contracts::Create.new(model)
      else
        TimeAllocation::Contracts::Update.new(model)
      end
  end

  def process(params)
    model = params[:id] ? TimeAllocation.find(params[:id]) : TimeAllocation.new

    if validate(params[:time_allocation], model)
      contract.save
    else
      raise 'TimeAllocation form has errors, which should not happen with our'\
            " user base: #{contract.errors.full_messages}"
    end
  end
end
