# frozen_string_literal: true
class ProductivityGoalsController < BackendController
  def index
  end

  def show
  end

  def new
    form ProductivityGoal::Create
  end

  def create
    run ProductivityGoal::Create
    render :show
  end

  def edit
    form ProductivityGoal::Update
  end

  def update
    run ProductivityGoal::Update
    render :edit
  end
end
