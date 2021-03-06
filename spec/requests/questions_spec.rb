require 'rails_helper'

RSpec.describe "Questions", type: :request do
  let (:question){ FactoryGirl.create(:question) }

  # Runs before each test.
  before do
    # Sign in as a user.
    sign_in_as_a_valid_user
  end

  describe "GET /questions" do
    it "works! (now write some real specs)" do
      get course_lesson_lesson_module_questions_path(lesson_module_id: question.lesson_module.id, lesson_id: question.lesson_module.lesson.id, course_id: question.lesson_module.lesson.course.id)
      expect(response).to have_http_status(200)
    end
  end
end
