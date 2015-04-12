require 'spec_helper'

describe 'users/show' do
  let(:user_attributes) { { 'id' => 523, 'username' => 'MyNewString', 'email' => 'newemail@localhost.home', 'password' => 'my_new_secret_pass', 'profile_id' => '3'} }
  let(:user_info_attributes) { { :user_id => 523, :first_name => "FirstName", :last_name => "LastName", :activated => true, :language_id => 1, :token => nil } }

  before(:each) do
    @current_user = User.create! ( { :username => 'Username', :password => 'Password', :email => 'email@email.home', :profile_id => '1' } )
    @user =  User.create! ( user_attributes )
    @user.user_info = UserInfo.create! ( user_info_attributes )
    @language = "MyLanguage"
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/FirstName/)
    rendered.should match(/LastName/)
  end
end
