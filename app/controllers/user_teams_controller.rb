# frozen_string_literal: true
class UserTeamsController < BackendController
  def index
  end

  def new
    form UserTeam::Create
  end

  def create
    run UserTeam::Create
    redirect_to :index
  end

  def edit
    form UserTeam::Update
  end

  def update
    run UserTeam::Update
    render :edit
  end
end
