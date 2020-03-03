module StatisticsHelper
  def stat_percent(val, total) 
    if total == 0
      return 0
    else
      (val.to_f/total.to_f * 100.0).round(2)
    end
  end
end
