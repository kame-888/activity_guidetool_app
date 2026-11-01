class CalendarsController < ApplicationController
  def show
    @month = parse_month(params[:month])
    @activities = Activity.order(:title)
    @activity = Activity.find_by(id: params[:activity_id]) if params[:activity_id].present?

    range = @month.beginning_of_month.beginning_of_week(:sunday)..@month.end_of_month.end_of_week(:sunday)
    @dates = range.to_a

    time_slots = TimeSlot.includes(:activity, :guide)
                         .where(starts_at: range.first.beginning_of_day..range.last.end_of_day)
                         .order(:starts_at)
    time_slots = time_slots.where(activity: @activity) if @activity

    @slots_by_date = time_slots.group_by { |slot| slot.starts_at.to_date }
    # 開催枠ごとの「注意事項がある参加者」の人数 { time_slot_id => count }
    @caution_counts = Participant.with_caution
                                 .where(time_slot_id: time_slots.map(&:id))
                                 .group(:time_slot_id)
                                 .count
  end

  private

  # "2026-11" 形式を受け付け、不正な値なら今月を返す
  def parse_month(value)
    Date.strptime(value.to_s, "%Y-%m")
  rescue Date::Error
    Date.current.beginning_of_month
  end
end
