require 'rails_helper'

RSpec.describe "events/show", type: :view do
  let (:lesson){ FactoryGirl.create(:lesson_no_call_backs) }
  let(:user) { FactoryGirl.create(:user) }
  let(:current_user) { user }

  before(:each) do
    @event = assign(:event, Event.create!(
      title: "Title",
      description: "MyText",
      start_time: DateTime.now,
      end_time: DateTime.now + 3.hours,
      lesson: lesson
    ))
    @lesson = lesson
    @course = lesson.course
    sign_in(user)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
  end
end
