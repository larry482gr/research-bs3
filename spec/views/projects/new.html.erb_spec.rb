require 'spec_helper'

describe "projects/new" do
  before(:each) do
    assign(:project, stub_model(Project,
      :title => "MyString",
      :description => "MyText",
      :is_private => false
    ).as_new_record)
  end

  it "renders new project form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", projects_path, "post" do
      assert_select "input#project_title[name=?]", "project[title]"
      assert_select "textarea#project_description[name=?]", "project[description]"
      assert_select "input#project_is_private[name=?]", "project[is_private]"
    end
  end
end
