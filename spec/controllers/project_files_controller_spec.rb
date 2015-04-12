require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe ProjectFilesController do

  # This should return the minimal set of attributes required to create a valid
  # ProjectFile. As you add validations to ProjectFile, be sure to
  # adjust the attributes here as well.
  let(:user_attributes) { { 'username' => 'MyString', 'email' => 'email@localhost.home', 'password' => 'my_secret_pass', 'profile_id' => '1'} }
  let(:project_attributes) { { 'title' => 'MyTitle', 'description' => 'MyDescription'} }
  before(:each) do
    @current_user = User.create! user_attributes
    UserInfo.create(:user_id => @current_user.id, :activated => true, :token => nil)
  end
  before(:each) do
    @project = Project.create! project_attributes
  end

  let(:valid_attributes) { { "project_id" => @project.id, "user_id" => @current_user.id, "filename" => "MyFilename", "filepath" => "/project_files/0/1/test_file.txt" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ProjectFilesController. Be sure to keep this updated too.
  let(:valid_session) { {} }


  describe "GET index" do
    it "assigns all project_files as project" do
      project_file = ProjectFile.create! valid_attributes
      get :index, { :project_id => project_file.project }, valid_session
      assigns(:project).should eq([project_file.project])
    end
  end

  describe "GET show" do
    it "assigns the requested project_file as @project_file" do
      project_file = ProjectFile.create! valid_attributes
      get :show, {:id => project_file.id, :project_id => project_file.project }, valid_session
      assigns(:project_file).should eq(project_file)
    end
  end

  describe "GET new" do
    it "assigns a new project_file as @project_file" do
      get :new, {}, valid_session
      assigns(:project_file).should be_a_new(ProjectFile)
    end
  end

  describe "GET edit" do
    it "assigns the requested project_file as @project_file" do
      project_file = ProjectFile.create! valid_attributes
      get :edit, {:id => project_file.id, :project_id => project_file.project }, valid_session
      assigns(:project_file).should eq(project_file)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new ProjectFile" do
        expect {
          post :create, {:project_file => valid_attributes}, valid_session
        }.to change(ProjectFile, :count).by(1)
      end

      it "assigns a newly created project_file as @project_file" do
        post :create, {:project_file => valid_attributes}, valid_session
        assigns(:project_file).should be_a(ProjectFile)
        assigns(:project_file).should be_persisted
      end

      it "redirects to the created project_file" do
        post :create, {:project_file => valid_attributes}, valid_session
        response.should redirect_to(ProjectFile.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved project_file as @project_file" do
        # Trigger the behavior that occurs when invalid params are submitted
        ProjectFile.any_instance.stub(:save).and_return(false)
        post :create, {:project_file => { "project" => "invalid value" }}, valid_session
        assigns(:project_file).should be_a_new(ProjectFile)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        ProjectFile.any_instance.stub(:save).and_return(false)
        post :create, {:project_file => { "project" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested project_file" do
        project_file = ProjectFile.create! valid_attributes
        # Assuming there are no other project_files in the database, this
        # specifies that the ProjectFile created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        ProjectFile.any_instance.should_receive(:update).with({ "project" => "" })
        put :update, {:id => project_file.id, :project_id => project_file.project }, valid_session
      end

      it "assigns the requested project_file as @project_file" do
        project_file = ProjectFile.create! valid_attributes
        put :update, {:id => project_file.id, :project_id => project_file.project }, valid_session
        assigns(:project_file).should eq(project_file)
      end

      it "redirects to the project_file" do
        project_file = ProjectFile.create! valid_attributes
        put :update, {:id => project_file.id, :project_id => project_file.project }, valid_session
        response.should redirect_to(project_file)
      end
    end

    describe "with invalid params" do
      it "assigns the project_file as @project_file" do
        project_file = ProjectFile.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        ProjectFile.any_instance.stub(:save).and_return(false)
        put :update, {:id => project_file.id, :project_id => project_file.project }, valid_session
        assigns(:project_file).should eq(project_file)
      end

      it "re-renders the 'edit' template" do
        project_file = ProjectFile.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        ProjectFile.any_instance.stub(:save).and_return(false)
        put :update, {:id => project_file.id, :project_id => project_file.project }, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested project_file" do
      project_file = ProjectFile.create! valid_attributes
      expect {
        delete :destroy, {:id => project_file.id, :project_id => project_file.project }, valid_session
      }.to change(ProjectFile, :count).by(-1)
    end

    it "redirects to the project_files list" do
      project_file = ProjectFile.create! valid_attributes
      delete :destroy, {:id => project_file.id, :project_id => project_file.project }, valid_session
      response.should redirect_to(project_files_url)
    end
  end

end
