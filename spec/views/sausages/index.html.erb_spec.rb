require 'spec_helper'

describe "sausages/index" do
  before(:each) do
    assign(:sausages, [
      stub_model(Sausage),
      stub_model(Sausage)
    ])
  end

  it "renders a list of sausages" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
