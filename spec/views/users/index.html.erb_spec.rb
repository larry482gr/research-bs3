require 'spec_helper'

describe "users/index" do
  let(:current_user_attributes) { { 'id' => 745, 'username' => 'MyString', 'email' => 'email@localhost.home', 'password' => 'my_secret_pass', 'profile_id' => '1'} }
  let(:user_attributes) { { 'id' => 523, 'username' => 'MyNewString', 'email' => 'newemail@localhost.home', 'password' => 'my_new_secret_pass', 'profile_id' => '3'} }
  let(:current_user_info_attributes) { { :user_id => 745, :first_name => "FirstName", :last_name => "LastName", :activated => true, :language_id => 1, :token => nil } }
  let(:user_info_attributes) { { :user_id => 523, :first_name => "FirstName", :last_name => "LastName", :activated => false, :language_id => 2, :token => nil } }

  before(:each) do
    @current_user = User.create! ( current_user_attributes )
    @user =  User.create! ( user_attributes )
    @current_user.user_info = UserInfo.create! ( current_user_info_attributes )
    @user.user_info = UserInfo.create! ( user_info_attributes )

    @users = User.all
  end

  it "renders a list of users" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyString (owner)".to_s, :count => 1
    assert_select "tr>td", :text => "MyNewString (user)".to_s, :count => 1
    assert_select "tr>td", :text => "newemail@localhost.home".to_s, :count => 1
    assert_select "tr>td", :text => "FirstName".to_s, :count => 2
  end
end
