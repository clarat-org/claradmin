# frozen_string_literal: true
# Polyfill to use Reform validations with old backend
# TODO: Remove every include of this with the model's usage in rails_admin
module ReformedValidationHack
  extend ActiveSupport::Concern

  included do
    before_validation(on: :create) { _rvhack_validate(:create) }
    before_validation(on: :update) { _rvhack_validate(:update) }

    def _rvhack_validate event
      # run other callbacks before validations
      @@before_hacks[self.class.name]&.each do |func|
        self.send(func)
      end
      contract = _rvhacky_contract_for(event).new(self)
      result = contract.validate(attributes)
      @errors = contract.errors
      result
    end

    def _rvhacky_contract_for event
      if event == :update && defined?(self.class::Contracts::Update)
        self.class::Contracts::Update
      else
        self.class::Contracts::Create
      end
    end

    def self.before_hack function
      # rubocop:disable Style/ClassVars
      @@before_hacks ||= {}
      @@before_hacks[self.name] ||= []
      @@before_hacks[self.name] << function
      # rubocop:enable Style/ClassVars
    end
  end
end
