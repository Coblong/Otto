require 'spec_helper'

describe "sausages/edit" do
  before(:each) do
    @sausage = assign(:sausage, stub_model(Sausage))
  end

  it "renders the edit sausage form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", sausage_path(@sausage), "post" do
    end
  end
end
