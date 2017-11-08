# frozen_string_literal: true

module Lib
  module Macros
    module Live
      def self.SendChanges
        step = ->(_, model:, **) do
          ActionCable.server.broadcast(
            'changes',
            model: model.class.table_name, id: model.id, changes: changes(model)
          )

          true
        end

        [step, name: 'live.send_changes']
      end

      private_class_method

      def self.changes(model)
        model.saved_changes.map { |attribute, change| [attribute, change[1]] }
             .to_h
      end
    end
  end
end
