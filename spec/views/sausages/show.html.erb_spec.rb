require 'spec_helper'

describe "sausages/show" do
  before(:each) do
    @sausage = assign(:sausage, stub_model(Sausage))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
