module CalendarsHelper
  WEEKDAY_LABELS = %w[日 月 火 水 木 金 土].freeze

  # 開催枠の表示色: 中止 > 注意事項あり > 通常 の優先順で判定
  def calendar_slot_class(slot, caution_count)
    if slot.cancelled?
      "calendar-slot calendar-slot--cancelled"
    elsif caution_count.to_i.positive?
      "calendar-slot calendar-slot--caution"
    else
      "calendar-slot calendar-slot--normal"
    end
  end

  def calendar_day_class(date, month)
    classes = [ "calendar-day" ]
    classes << "calendar-day--outside" unless date.month == month.month
    classes << "calendar-day--today" if date == Date.current
    classes << "calendar-day--sun" if date.sunday?
    classes << "calendar-day--sat" if date.saturday?
    classes.join(" ")
  end

  def calendar_month_param(date)
    date.strftime("%Y-%m")
  end
end
