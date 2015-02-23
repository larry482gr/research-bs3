json.array!(@project_files) do |project_file|
  json.extract! project_file, :project_id, :user_id, :filename, :is_basic
  json.url project_file_url(project_file, format: :json)
end
