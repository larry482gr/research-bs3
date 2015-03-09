# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Language.create([{id: 1, locale: 'en', language: 'english'}, {id: 2, locale: 'gr', language: 'greek'}])

owner = Profile.create(id: 1, label: 'owner', description: 'Application Owner')
admin = Profile.create(id: 2, label: 'admin', description: 'Application Administrator')
user  = Profile.create(id: 3, label: 'user', description: 'Single User')

user_rights = [Right.create(label: 'user_list', description: 'List other users\' profiles'),
               Right.create(label: 'user_show', description: 'Show users'),
               Right.create(label: 'user_create', description: 'Create users'),
               Right.create(label: 'user_edit', description: 'Edit users'),
               Right.create(label: 'user_delete', description: 'Delete users')]

owner.rights += user_rights
admin.rights += user_rights

self_rights = [Right.create(label: 'user_self_edit', description: 'Edit self account'),
               Right.create(label: 'user_self_delete', description: 'Delete self account')]

owner.rights += self_rights
admin.rights += self_rights
user.rights  += self_rights

ProjectProfile.create([{ id: 4, label: 'owner', description: 'Project Owner'}, { id: 5, label: 'collaborator', description: 'Project Collaborator' }])