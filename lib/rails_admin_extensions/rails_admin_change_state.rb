# frozen_string_literal: true
require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdminChangeState
end

module RailsAdmin
  module Config
    module Actions
      class ChangeState < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        # There are several options that you can set here.
        # Check https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config/actions/base.rb for more info.

        register_instance_option :visible? do
          false
        end

        register_instance_option :member? do
          true
        end

        register_instance_option :controller do
          proc do
            old_state = @object.aasm_state
            if @object.valid? && @object.send("#{params[:event]}!")
              flash[:success] = t('.success')
              Statistic::CountHandler.record(
                current_user, @object.class.name, 'aasm_state',
                old_state, @object.aasm_state
              )
            else
              error_message = t('.invalid', obj: @object.class.to_s)
              @object.errors.full_messages.each do |message|
                error_message += '<br/>' + message
              end
              flash[:error] = error_message.html_safe
            end

            redirect_to :back
          end
        end
      end
    end
  end
end
