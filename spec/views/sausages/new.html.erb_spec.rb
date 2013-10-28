require 'spec_helper'

describe "sausages/new" do
  before(:each) do
    assign(:sausage, stub_model(Sausage).as_new_record)
  end

  it "renders new sausage form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", sausages_path, "post" do
    end
  end
end
