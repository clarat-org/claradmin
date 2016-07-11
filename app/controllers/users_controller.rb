# frozen_string_literal: true
class UsersController < BackendController
  def index
  end

  def edit
    form User::Update
  end

  def update
    run User::Update
    render :edit
  end
end
