# frozen_string_literal: true
module Email::Contracts
  class Create < Reform::Form
    property :address
    property :aasm_state
  end
end
