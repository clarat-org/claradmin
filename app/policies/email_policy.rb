# frozen_string_literal: true
class EmailPolicy < ApplicationPolicy
  def create?
    true
  end
end
