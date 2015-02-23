require 'spec_helper'

describe "project_files/edit" do
  before(:each) do
    @project_file = assign(:project_file, stub_model(ProjectFile,
      :project => nil,
      :user => nil,
      :filename => "MyString",
      :is_basic => false
    ))
  end

  it "renders the edit project_file form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", project_file_path(@project_file), "post" do
      assert_select "input#project_file_project[name=?]", "project_file[project]"
      assert_select "input#project_file_user[name=?]", "project_file[user]"
      assert_select "input#project_file_filename[name=?]", "project_file[filename]"
      assert_select "input#project_file_is_basic[name=?]", "project_file[is_basic]"
    end
  end
end
