# frozen_string_literal: true
class UserTeam
  class Create < Trailblazer::Operation
    include Model
    model UserTeam, :create

    include Trailblazer::Operation::Policy
    policy UserTeamPolicy, :create?

    contract do
      property :name
      property :users
    end

    def process(params)
      validate(params[:user_team]) do |form_object|
        form_object.save
      end
    end
  end

  class Update < Trailblazer::Operation
    include Model
    model UserTeam, :update

    include Trailblazer::Operation::Policy
    policy UserTeamPolicy, :update?

    contract do
      property :name
      property :users
    end

    def process(params)
      validate(params[:user_team]) do |form_object|
        form_object.save
      end
    end
  end
end
