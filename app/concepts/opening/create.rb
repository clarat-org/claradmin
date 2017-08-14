# frozen_string_literal: true
class Opening::Create < Trailblazer::Operation
  step Model(::Opening, :new)
  step Policy::Pundit(OpeningPolicy, :create?)

  step Contract::Build(constant: Opening::Contracts::Create)
  step :generate_name
  step :calculate_sort_value
  step Contract::Validate()
  step Contract::Persist()

  def generate_name options
    day = options['params']['data']['attributes']['day']
    open = options['params']['data']['attributes']['open']
    close = options['params']['data']['attributes']['close']
    options['contract.default'].name = concat_day_and_times day, open, close
  end

  # rails_admin can only sort by a single field, that's why we are creating an
  # imaginary time stamp that handles the sorting
  def calculate_sort_value options
    day = options['params']['data']['attributes']['day']
    open = options['params']['data']['attributes']['open']
    close = options['params']['data']['attributes']['close']
    return nil unless day
    # const DAYS = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun']
    dummy_time = dummy_time_for_day Opening::DAYS.index(day) + 1, open, close
    options['contract.default'].sort_value = (dummy_time.to_f * 100).to_i
  end

  private

  def concat_day_and_times day, open, close
    if day && open && close
      "#{day.titleize} #{open}-#{close}"
    elsif day
      "#{day.titleize} (appointment)"
    end
  end

  # generate imaginary timestamp for a specific day
  def dummy_time_for_day day_nr, open, close
    if open && close
      hour = Time.parse(open).hour
      min = Time.parse(open).min
      sec = Time.parse(close).hour + Time.parse(close).min / 100.0
    else
      hour = min = sec = 0
    end
    Time.zone.local(1970, 1, day_nr, hour, min, sec, 0)
  end
end
