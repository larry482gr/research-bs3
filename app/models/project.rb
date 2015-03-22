class Project < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_and_belongs_to_many :citations
  has_many :project_files
  has_many :history_reports
  has_many :history_projects
  
  validates :title, presence: true
  validates :description, presence: true

  def owner?(user_id)
    puts "\n\n\n"
    puts User.all()

    query = "SELECT project_profile_id FROM projects_users
  			     WHERE user_id = #{user_id} AND project_id = #{self.id}"
    result = ActiveRecord::Base.connection.exec_query(query)

    return result.to_hash[0]['project_profile_id'].to_i == 1 unless result.empty?
  end

  def contributor?(user_id)
    query = "SELECT project_profile_id FROM projects_users
  			     WHERE user_id = #{user_id} AND project_id = #{self.id}"
    result = ActiveRecord::Base.connection.exec_query(query)

    return result.to_hash[0]['project_profile_id'].to_i == 2 unless result.empty?
  end
  
  def getModificationTime
  	timestamp_difference = Time.now.to_i - self.updated_at.to_i
    return self.timeToString(timestamp_difference)
  end
  
  def update_citation(doc_id, citation_type)
    cite_id		= ActiveRecord::Base.connection.quote(doc_id)
    cite_type	= ActiveRecord::Base.connection.quote(citation_type)
  	query = "UPDATE citations_projects
  			 SET citation_type = #{cite_type}
  			 WHERE project_id = #{self.id}
  			 AND citation_id = #{cite_id}"
    
    return ActiveRecord::Base.connection.update_sql(query)
  end
  
  def insert_citation (doc_id, citation_type)
    cite_id		= ActiveRecord::Base.connection.quote(doc_id)
    cite_type	= ActiveRecord::Base.connection.quote(citation_type)
  	query = "INSERT INTO citations_projects
  			 VALUES (#{self.id}, #{cite_id}, #{cite_type})"
    
    return ActiveRecord::Base.connection.insert_sql(query)
  end
  
  protected

  after_save :set_default_profile

  def set_default_profile
    query = "UPDATE projects_users
  			 SET project_profile_id = 1
  			 WHERE project_id = #{self.id}"

    ActiveRecord::Base.connection.update_sql(query)
  end
  
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