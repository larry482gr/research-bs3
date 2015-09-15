# Copyright 2015 Kazantzis Lazaros

json.extract! @user, :username, :email
json.extract! @user.user_info, :first_name, :last_name, :language_id
