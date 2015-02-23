require 'spec_helper'

describe "project_files/new" do
  before(:each) do
    assign(:project_file, stub_model(ProjectFile,
      :project => nil,
      :user => nil,
      :filename => "MyString",
      :is_basic => false
    ).as_new_record)
  end

  it "renders new project_file form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", project_files_path, "post" do
      assert_select "input#project_file_project[name=?]", "project_file[project]"
      assert_select "input#project_file_user[name=?]", "project_file[user]"
      assert_select "input#project_file_filename[name=?]", "project_file[filename]"
      assert_select "input#project_file_is_basic[name=?]", "project_file[is_basic]"
    end
  end
end
