# frozen_string_literal: true

module Lib
  module Macros
    module Live
      def self.SendChanges
        step = ->(_, model:, **) do
          broadcast_change(model, changes(model))

          true
        end

        [step, name: 'live.send_changes']
      end

      def self.SendCreation
        step = ->(_, model:, **) do
          ActionCable.server.broadcast(
            'changes',
            model: model.class.table_name.dasherize,
            action: 'addition', json: show_representer(model).to_hash
          )
        end

        [step, name: 'live.send_creation']
      end

      def self.SendDeletion
        step = ->(_, model:, **) do
          ActionCable.server.broadcast(
            'changes',
            model: model.class.table_name.dasherize, id: model.id,
            action: 'deletion'
          )
        end

        [step, name: 'live.send_deletion']
      end

      def self.broadcast_change model, data
        ActionCable.server.broadcast(
          'changes',
          model: model.class.table_name.dasherize, id: model.id,
          action: 'change', changes: data
        )
      end

      private_class_method

      def self.changes(model)
        model.saved_changes.map do |attribute, change|
          [attribute.dasherize, change[1]]
        end.to_h
      end

      def self.show_representer model
        "API::V1::#{model.class.name}::Representer::Show".constantize.new model
      end
    end
  end
end
