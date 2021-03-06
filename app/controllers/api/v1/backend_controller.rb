# frozen_string_literal: true

module API::V1
  class BackendController < ApplicationController
    include Trailblazer::Endpoint::Controller
    respond_to :json

    # --- Default Action Handlers --- #

    def index
      # NOTE: use api_args instead of only params??
      result = index_operation.(params)
      if result.success?
        json = API::V1::Lib::JsonifyCollection.(
          index_representer, result['collection'], params
        )
        return render(json: json, status: 200)
      end
    end

    def show
      @model = model_class_name.constantize.find(params[:id])
      render json: show_representer.new(@model).to_json
    end

    def create
      custom_endpoint create_operation.(*api_args), 201
    end

    def update
      custom_endpoint update_operation.(*api_args), 200
    end

    def destroy
      result = delete_operation.(
        params,
        'current_user' => current_user,
        'model_class': model_class_name.constantize
      )
      if result.success?
        render json: {}, status: 200
      else
        render json: jsonapi_errors(result), status: 403
      end
    end

    # --- Non-Action Helper methods --- #

    def render(*attrs)
      attrs.push({}) unless attrs[-1]
      attrs[-1][:content_type] = 'application/vnd.api+json'
      super(*attrs)
    end

    def api_args
      [params, {
        'current_user' => current_user,
        'document' => request.raw_post
      }]
    end

    def custom_endpoint(result, success_status)
      if result.success?
        render json: show_representer.new(result['model']),
               status: success_status
      else
        render json: jsonapi_errors(result), status: 403
      end
    end

    def model_class_name
      controller_name.classify
    end

    def base_module
      "API::V1::#{model_class_name}"
    end

    def show_representer
      "#{base_module}::Representer::Show".constantize
    end

    def index_representer
      "#{base_module}::Representer::Index".constantize
    end

    def index_operation
      "#{base_module}::Index".constantize
    end

    def create_operation
      "#{base_module}::Create".constantize
    end

    def update_operation
      "#{base_module}::Update".constantize
    end

    def delete_operation
      "::#{model_class_name}::Delete".constantize
    rescue NameError
      ::Default::Delete
    end

    def jsonapi_errors(result)
      JsonapiErrors.generate(result)
    end
  end
end
