require "spec_helper"

describe SausagesController do
  describe "routing" do

    it "routes to #index" do
      get("/sausages").should route_to("sausages#index")
    end

    it "routes to #new" do
      get("/sausages/new").should route_to("sausages#new")
    end

    it "routes to #show" do
      get("/sausages/1").should route_to("sausages#show", :id => "1")
    end

    it "routes to #edit" do
      get("/sausages/1/edit").should route_to("sausages#edit", :id => "1")
    end

    it "routes to #create" do
      post("/sausages").should route_to("sausages#create")
    end

    it "routes to #update" do
      put("/sausages/1").should route_to("sausages#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/sausages/1").should route_to("sausages#destroy", :id => "1")
    end

  end
end
