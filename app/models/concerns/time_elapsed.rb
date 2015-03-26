module TimeElapsed
  extend ActiveSupport::Concern

  def getModificationTime
    timestamp_difference = Time.now.to_i - self.updated_at.to_i
    return self.timeToString(timestamp_difference)
  end

  protected
  #{pluralize(@user.errors.count, (I18n.t :error))}

  def timeToString(timestamp_difference)
    case timestamp_difference
      when (365*86400)..Time.now.to_i
        return "#{(I18n.t :more_than)} #{I18n.t :year, count: timestamp_difference/365*86400} #{(I18n.t :ago)}"
      when 30*86400..(365*86400-1)
        return "#{I18n.t :month, count: timestamp_difference/30*86400} #{(I18n.t :ago)}"
        # return "#{timestamp_difference/30*86400} month(s) ago"
      when 86400..(30*86400-1)
        return "#{I18n.t :day, count: timestamp_difference/86400} #{(I18n.t :ago)}"
        # return "#{timestamp_difference/86400} day(s) ago"
      when 3600..(86400-1)
        return "#{I18n.t :hour, count: timestamp_difference/3600} #{(I18n.t :ago)}"
        # return "#{timestamp_difference/3600} hour(s) ago"
      when 60..(3600-1)
        return "#{I18n.t :minute, count: timestamp_difference/60} #{(I18n.t :ago)}"
        # return "#{timestamp_difference/60} minute(s) ago"
      else
        return (I18n.t :few_seconds)
    end
  end
end