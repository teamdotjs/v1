require 'rails_helper'

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

RSpec.describe LessonsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Lesson. As you add validations to Lesson, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {
      lesson_name: 'Lesson 1',
      lesson_points: 30,
      lesson_start_time: DateTime.now,
      lesson_end_date: DateTime.now + 1.week,
      course: FactoryGirl.create(:course),
      penalty: 10
    }
  }

  let(:invalid_attributes) {
    {
        lesson_name: nil,
        lesson_points: nil,
        lesson_start_time: nil,
        lesson_end_date: nil,
        course_id: nil,
        penalty: nil
    }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # LessonsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all lessons as @lessons" do
      lesson = Lesson.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:lessons)).to eq([lesson])
    end
  end

  describe "GET #show" do
    it "assigns the requested lesson as @lesson" do
      lesson = Lesson.create! valid_attributes
      get :show, {:id => lesson.to_param}, valid_session
      expect(assigns(:lesson)).to eq(lesson)
    end
  end

  describe "GET #new" do
    it "assigns a new lesson as @lesson" do
      get :new, {}, valid_session
      expect(assigns(:lesson)).to be_a_new(Lesson)
    end
  end

  describe "GET #edit" do
    it "assigns the requested lesson as @lesson" do
      lesson = Lesson.create! valid_attributes
      get :edit, {:id => lesson.to_param}, valid_session
      expect(assigns(:lesson)).to eq(lesson)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Lesson" do
        expect {
          post :create, {:lesson => valid_attributes}, valid_session
        }.to change(Lesson, :count).by(1)
      end

      it "assigns a newly created lesson as @lesson" do
        post :create, {:lesson => valid_attributes}, valid_session
        expect(assigns(:lesson)).to be_a(Lesson)
        expect(assigns(:lesson)).to be_persisted
      end

      it "redirects to the created lesson" do
        post :create, {:lesson => valid_attributes}, valid_session
        expect(response).to redirect_to(Lesson.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved lesson as @lesson" do
        post :create, {:lesson => invalid_attributes}, valid_session
        expect(assigns(:lesson)).to be_a_new(Lesson)
      end

      it "re-renders the 'new' template" do
        post :create, {:lesson => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {
            lesson_name: 'Lesson 2'
        }
      }

      it "updates the requested lesson" do
        lesson = Lesson.create! valid_attributes
        put :update, {:id => lesson.to_param, :lesson => new_attributes}, valid_session
        lesson.reload
        expect(assigns(:course).attributes.symbolize_keys[:lesson_name]).to eq(new_attributes[:lesson_name])
      end

      it "assigns the requested lesson as @lesson" do
        lesson = Lesson.create! valid_attributes
        put :update, {:id => lesson.to_param, :lesson => valid_attributes}, valid_session
        expect(assigns(:lesson)).to eq(lesson)
      end

      it "redirects to the lesson" do
        lesson = Lesson.create! valid_attributes
        put :update, {:id => lesson.to_param, :lesson => valid_attributes}, valid_session
        expect(response).to redirect_to(lesson)
      end
    end

    context "with invalid params" do
      it "assigns the lesson as @lesson" do
        lesson = Lesson.create! valid_attributes
        put :update, {:id => lesson.to_param, :lesson => invalid_attributes}, valid_session
        expect(assigns(:lesson)).to eq(lesson)
      end

      it "re-renders the 'edit' template" do
        lesson = Lesson.create! valid_attributes
        put :update, {:id => lesson.to_param, :lesson => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested lesson" do
      lesson = Lesson.create! valid_attributes
      expect {
        delete :destroy, {:id => lesson.to_param}, valid_session
      }.to change(Lesson, :count).by(-1)
    end

    it "redirects to the lessons list" do
      lesson = Lesson.create! valid_attributes
      delete :destroy, {:id => lesson.to_param}, valid_session
      expect(response).to redirect_to(lessons_url)
    end
  end

end
