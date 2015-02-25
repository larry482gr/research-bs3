# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

languages = Language.create([{id: 1, locale: 'en', language: 'english'}, {id: 2, locale: 'gr', language: 'greek'}])

profiles = Profile.create([{id: 1, label: 'owner', description: 'Application Owner'}, {id: 2, label: 'admin', description: 'Application Administrator' }, {id: 3, label: 'user', description: 'Single User'}])

project_profiles = ProjectProfile.create([{ id: 4, label: 'owner', description: 'Project Owner'}, { id: 5, label: 'collaborator', description: 'Project Collaborator' }])