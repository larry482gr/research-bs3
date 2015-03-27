class Project < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_and_belongs_to_many :citations

  has_many :project_files
  has_many :invitations

  has_many :history_reports
  has_many :history_projects
  
  validates :title, presence: true
  validates :description, presence: true

  include TimeElapsed

  def owner?(user_id)
    user_id		= ActiveRecord::Base.connection.quote(user_id)
    self_id	= ActiveRecord::Base.connection.quote(self.id)

    query = "SELECT project_profile_id FROM projects_users
  			     WHERE user_id = #{user_id} AND project_id = #{self_id}"

    result = ActiveRecord::Base.connection.exec_query(query)

    return result.to_hash[0]['project_profile_id'].to_i == 1 unless result.empty?
  end

  def contributor?(user_id)
    user_id		= ActiveRecord::Base.connection.quote(user_id)
    self_id	= ActiveRecord::Base.connection.quote(self.id)

    query = "SELECT project_profile_id FROM projects_users
  			     WHERE user_id = #{user_id} AND project_id = #{self_id}"

    result = ActiveRecord::Base.connection.exec_query(query)

    return result.to_hash[0]['project_profile_id'].to_i == 2 unless result.empty?
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

  def add_user(user_id, project_profile)
    self_id = ActiveRecord::Base.connection.quote(self.id)
    user_id = ActiveRecord::Base.connection.quote(user_id)
    project_profile = ActiveRecord::Base.connection.quote(project_profile)

    query = "INSERT INTO projects_users
  			 VALUES (#{user_id}, #{self_id}, #{project_profile})"

    ActiveRecord::Base.connection.update_sql(query)
  end
  
  protected

  after_save :set_default_profile

  def set_default_profile
    self_id = ActiveRecord::Base.connection.quote(self.id)

    query = "UPDATE projects_users
  			 SET project_profile_id = 1
  			 WHERE project_id = #{self_id}"

    ActiveRecord::Base.connection.update_sql(query)
  end
  
end