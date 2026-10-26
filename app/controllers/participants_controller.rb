# app/controllers/participants_controller.rb
class ParticipantsController < ApplicationController
  before_action :require_manager!
  before_action :set_time_slot, only: %i[new create]
  before_action :set_participant, only: %i[edit update destroy]

  def new
    @participant = @time_slot.participants.build
  end

  def create
    @participant = @time_slot.participants.build(participant_params)
    if @participant.save
      redirect_to @time_slot, notice: "参加者を登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @time_slot = @participant.time_slot
  end

  def update
    @time_slot = @participant.time_slot
    if @participant.update(participant_params)
      redirect_to @time_slot, notice: "参加者を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    time_slot = @participant.time_slot
    @participant.destroy
    redirect_to time_slot, notice: "参加者を削除しました", status: :see_other
  end

  private

  def set_time_slot
    @time_slot = TimeSlot.find(params[:time_slot_id])
  end

  def set_participant
    @participant = Participant.find(params[:id])
  end

  def participant_params
    params.require(:participant).permit(:name, :age, :caution_category, :caution_detail)
  end
end
