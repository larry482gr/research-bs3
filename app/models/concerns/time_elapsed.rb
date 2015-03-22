module TimeElapsed
  extend ActiveSupport::Concern

  def getModificationTime
    timestamp_difference = Time.now.to_i - self.updated_at.to_i
    return self.timeToString(timestamp_difference)
  end

  protected

  def timeToString(timestamp_difference)
    case timestamp_difference
      when (365*86400)..Time.now.to_i
        return "more than #{timestamp_difference/365*86400} year(s) ago"
      when 30*86400..(365*86400-1)
        return "#{timestamp_difference/30*86400} month(s) ago"
      when 86400..(30*86400-1)
        return "#{timestamp_difference/86400} day(s) ago"
      when 3600..(86400-1)
        return "#{timestamp_difference/3600} hour(s) ago"
      when 60..(3600-1)
        return "#{timestamp_difference/60} minute(s) ago"
      else
        return 'a few seconds ago'
    end
  end
end