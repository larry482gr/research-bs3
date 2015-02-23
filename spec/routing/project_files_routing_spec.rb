require "spec_helper"

describe ProjectFilesController do
  describe "routing" do

    it "routes to #index" do
      get("/project_files").should route_to("project_files#index")
    end

    it "routes to #new" do
      get("/project_files/new").should route_to("project_files#new")
    end

    it "routes to #show" do
      get("/project_files/1").should route_to("project_files#show", :id => "1")
    end

    it "routes to #edit" do
      get("/project_files/1/edit").should route_to("project_files#edit", :id => "1")
    end

    it "routes to #create" do
      post("/project_files").should route_to("project_files#create")
    end

    it "routes to #update" do
      put("/project_files/1").should route_to("project_files#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/project_files/1").should route_to("project_files#destroy", :id => "1")
    end

  end
end
