# frozen_string_literal: true
module API::V1
  module FieldSet
    class Show < Representable::Decorator
      include Representable::JSON

      property :'column-names', getter: ->(r) do
        r[:represented].column_names.map(&:dasherize)
      end

      property :associations, getter: ->(r) do
        def filter_name_for_association(assoc)
          results = []
          # puts assoc.name
          # puts assoc.options
          # puts '------------'
          if !assoc.options[:inverse_of] || assoc.options[:polymorphic] ||
             assoc.is_a?(::ActiveRecord::Reflection::BelongsToReflection)
            results.push('')
          elsif assoc.options[:inverse_of].to_s.ends_with?('able') # polymorphic associations (_type & _id)
            polymorphic_name = assoc.options[:inverse_of]
            results.push "#{polymorphic_name}_id"
            results.push "#{polymorphic_name}_type"
          else
            name = assoc.options[:inverse_of]
            is_plural = name.to_s == name.to_s.pluralize
            prefix = assoc.options[:through] && !is_plural ? assoc.options[:through].to_s.singularize + '.' : ''
            results.push(is_plural ? "#{name}.id" : "#{prefix}#{name.to_s.singularize}_id")
          end
          results
        end

        assocs = {}
        r[:represented].reflect_on_all_associations.each do |assoc|
          # NOTE: Hotfixed to avoid polymorphic modules as association
          next if assoc.options[:polymorphic]
          # build association object
          class_name = assoc.options[:class_name] ? assoc.options[:class_name].underscore.pluralize : assoc.name
          keys = filter_name_for_association(assoc)
          assocs[assoc.name] = {
            'columns' => assoc.klass.column_names.map(&:dasherize),
            'class-name' => class_name,
            'key' => keys
          }
        end
        assocs
      end
    end
  end
end
