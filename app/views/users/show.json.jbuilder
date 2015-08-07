# json.extract! @user, :username, :email
# json.extract! @user.user_info, :first_name, :last_name, :language_id
json.extract! @json_response, :username, :email, :fname, :lname, :lang
