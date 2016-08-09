# frozen_string_literal: true
class TimeAllocation::IndexCell < Cell::Concept
  property :name

  def show
    render
  end

  private

  include Cell::SimpleFormCell
  include Backend::FormFields::Methods

  def form &block
    simple_form_for(model, url: time_allocations_path, &block)
  end
end
