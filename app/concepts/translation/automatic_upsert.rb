# frozen_string_literal: true
module Translation
  class AutomaticUpsert < Trailblazer::Operation
    step :generate_translation_params
    step :find_and_add_acting_user_to_options
    step :add_specific_create_or_update_params
    step :call_nested_specific_create_or_update

    def generate_translation_params(options)
      found_model = query_for_existing_model(options).first

      new_params =
        if found_model && found_model.manually_edited?
          # Translation was already edited by a human, so it is not updated
          # with a new translation but flagged as possibly outdated
          { possibly_outdated: true }
        else
          generate_field_translations(options)
        end

      options['params'] = options['params'].merge(new_params)
    end

    def find_and_add_acting_user_to_options(options)
      user_id =
        if options['object_to_translate'].approved_by
          options['object_to_translate'].approved_by
        else
          options['object_to_translate'].created_by
        end
      options['last_acting_user'] = User.find(user_id)
    end

    def add_specific_create_or_update_params(options)
      found_model = query_for_existing_model(options).first
      if found_model
        options['nested.operation'] = model_class(options)::Update
        options['params'][:id] = found_model.id
      else
        options['nested.operation'] = model_class(options)::Create
        options['params']['locale'] = options['locale']
      end
      options['params'][id_field(options)] = options['object_to_translate'].id
    end

    def call_nested_specific_create_or_update(options, params:, last_acting_user:, **)
      result = options['nested.operation'].(params, 'current_user' => last_acting_user)
      options['nested.result'] = result
      result.success?
    end

    # --- helper functions for inferring and querying --- #

    def query_for_existing_model(options)
      model_class(options).where(
        locale: options['locale'],
        id_field(options) => options['object_to_translate'].id
      )
    end

    def id_field(options)
      options['object_to_translate'].class.name.underscore + '_id'
    end

    def model_class(options)
      "#{options['object_to_translate'].class.name}Translation".constantize
    end

    # --- Logic for automatic translations --- #

    def generate_field_translations options
      params_hash = direct_translate_to_html(options)

      if options['locale'].to_sym == :de
        params_hash['source'] = 'researcher'
      else
        params_hash = GoogleTranslateCommunicator.get_translations(
          params_hash, options['locale']
        )
        params_hash['source'] = 'GoogleTranslate'
      end
      params_hash
    end

    def direct_translate_to_html options
      params_hash = {}
      fields = options['fields']
      object = options['object_to_translate']
      fields_to_translate =
        fields.to_s == 'all' ? object.translated_fields : fields

      fields_to_translate.each do |field|
        params_hash[field] =
          direct_translate_via_strategy(object, field, options['locale'])
      end

      params_hash
    end

    def direct_translate_via_strategy object, field, locale
      case field.to_sym
      when :name
        object.untranslated_name
      when :description
        output = MarkdownRenderer.render(object.untranslated_description)
        output = Definition.infuse(output) if locale.to_sym == :de
        output
      when :old_next_steps, :opening_specification
        MarkdownRenderer.render object.send("untranslated_#{field}")
      else
        raise "Translation::AutomaticUpsert: #{field} needs translation strategy"
      end
    end
  end
end