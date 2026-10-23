# app/controllers/time_slots_controller.rb
class TimeSlotsController < ApplicationController
  before_action :require_manager!, except: :show
  before_action :set_activity, only: %i[new create]
  before_action :set_time_slot, only: %i[show edit update destroy]

  def show
    @activity = @time_slot.activity
    @participants = @time_slot.participants.order(:id)
  end

  def new
    @time_slot = @activity.time_slots.build
  end

  def create
    @time_slot = @activity.time_slots.build(time_slot_params)
    if @time_slot.save
      redirect_to @activity, notice: "開催枠を登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @activity = @time_slot.activity
  end

  def update
    @activity = @time_slot.activity
    if @time_slot.update(time_slot_params)
      redirect_to @activity, notice: "開催枠を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    activity = @time_slot.activity
    @time_slot.destroy
    redirect_to activity, notice: "開催枠を削除しました", status: :see_other
  end

  private

  def set_activity
    @activity = Activity.find(params[:activity_id])
  end

  def set_time_slot
    @time_slot = TimeSlot.find(params[:id])
  end

  def time_slot_params
    params.require(:time_slot).permit(:starts_at, :ends_at, :status, :memo)
  end
end
