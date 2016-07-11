# frozen_string_literal: true
class User::Update < Trailblazer::Operation
  include Model
  model User, :update

  include Trailblazer::Operation::Policy
  policy UserPolicy, :update?

  contract do
    property :name
    property :email
    property :password#, virtual: true
  end

  def process(params)
    validate(params[:user]) do |form_object|
      form_object.save
    end
  end
end
