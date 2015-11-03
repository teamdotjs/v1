require 'rails_helper'

RSpec.describe "courses/show", type: :view do
  before(:each) do
    @course = assign(:course, Course.create!(
      class_name: "Class Name",
      start_date: Date.today,
      end_date: Date.today + 3.months
    ))
    @course.users.build
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Class Name/)
  end
end
