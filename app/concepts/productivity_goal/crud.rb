# frozen_string_literal: true
class ProductivityGoal::Create < Trailblazer::Operation
  include Model
  model ProductivityGoal, :create

  include Trailblazer::Operation::Policy
  policy ProductivityGoalPolicy, :create?

  contract do
    property :title
    property :starts_at
    property :ends_at
    property :target_model
    property :target_count
    property :target_field_name
    property :target_field_value
    property :user_team_id

    validates :title, presence: true
    validates :starts_at, presence: true
    validates :ends_at, presence: true
    validates :target_model, presence: true
    validates :target_count, presence: true
    validates :target_field_name, presence: true
    validates :target_field_value, presence: true
    validates :user_team_id, presence: true

    # TODO: validate target_field_name & _value in combination with all others
  end

  def process(params)
    validate(params[:productivity_goal]) do |form_object|
      form_object.save
    end
  end
end

class ProductivityGoal::Update < Trailblazer::Operation
  include Model
  model ProductivityGoal, :update

  include Trailblazer::Operation::Policy
  policy ProductivityGoalPolicy, :update?

  contract do
    property :title
  end

  def process(params)
    validate(params[:productivity_goal]) do |form_object|
      form_object.save
    end
  end
end
