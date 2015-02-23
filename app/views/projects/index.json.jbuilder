json.array!(@projects) do |project|
  json.extract! project, :title, :description, :is_private
  json.url project_url(project, format: :json)
end
