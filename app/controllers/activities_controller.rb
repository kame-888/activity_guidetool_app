class ActivitiesController < ApplicationController
  before_action :require_manager!, except: %i[index show]
  before_action :set_activity, only: %i[show edit update destroy]

  def index
    @q = Activity.ransack(params[:q])
    @activities = @q.result(distinct: true).order(:id).page(params[:page]).per(10)
    @favorite_ids = current_user.favorite_activity_ids
  end

  def show
    @time_slots = @activity.time_slots.order(:starts_at)
  end

  def new
    @activity = Activity.new
  end

  def create
    @activity = Activity.new(activity_params)
    if @activity.save
      redirect_to @activity, notice: "アクティビティを登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @activity.update(activity_params)
      redirect_to @activity, notice: "アクティビティを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @activity.destroy
      redirect_to activities_path, notice: "アクティビティを削除しました", status: :see_other
    else
      redirect_to @activity, alert: "開催枠が残っているため削除できません", status: :see_other
    end
  end

  private

  def set_activity
    @activity = Activity.find(params[:id])
  end

  def activity_params
    params.require(:activity).permit(:title, :genre, :duration_minutes)
  end
end