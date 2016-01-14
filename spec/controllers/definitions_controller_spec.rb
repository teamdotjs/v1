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

RSpec.describe DefinitionsController, type: :controller do
  login_admin

  # This should return the minimal set of attributes required to create a valid
  # Definition. As you add validations to Definition, be sure to
  # adjust the attributes here as well.
  let(:word) { FactoryGirl.create(:word) }
  let(:valid_attributes) {
    {
        word_definition: "This is a word definition",
        word_id: word.id
    }
  }

  let(:invalid_attributes) {
    {
        word_definition: "" #must be longer than 6 characters
    }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # DefinitionsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all definitions as @definitions" do
      definition = Definition.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:definitions)).to eq([definition])
    end
  end

  describe "GET #show" do
    it "assigns the requested definition as @definition" do
      definition = Definition.create! valid_attributes
      get :show, {:id => definition.to_param}, valid_session
      expect(assigns(:definition)).to eq(definition)
    end
  end

  describe "GET #new" do
    it "assigns a new definition as @definition" do
      get :new, {}, valid_session
      expect(assigns(:definition)).to be_a_new(Definition)
    end
  end

  describe "GET #edit" do
    it "assigns the requested definition as @definition" do
      definition = Definition.create! valid_attributes
      get :edit, {:id => definition.to_param}, valid_session
      expect(assigns(:definition)).to eq(definition)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Definition" do
        expect {
          post :create, {:definition => valid_attributes}, valid_session
        }.to change(Definition, :count).by(1)
      end

      it "assigns a newly created definition as @definition" do
        post :create, {:definition => valid_attributes}, valid_session
        expect(assigns(:definition)).to be_a(Definition)
        expect(assigns(:definition)).to be_persisted
      end

      it "redirects to the created definition" do
        post :create, {:definition => valid_attributes}, valid_session
        expect(response).to redirect_to(word)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved definition as @definition" do
        post :create, {:definition => invalid_attributes}, valid_session
        expect(assigns(:definition)).to be_a_new(Definition)
      end

      it "re-renders the 'new' template" do
        post :create, {:definition => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {
            word_definition: "Updated word definition"
        }
      }

      it "updates the requested definition" do
        definition = Definition.create! valid_attributes
        put :update, {:id => definition.to_param, :definition => new_attributes}, valid_session
        definition.reload
        expect(assigns(:definition).attributes.symbolize_keys[:word_definition]).to eq(new_attributes[:word_definition])
      end

      it "assigns the requested definition as @definition" do
        definition = Definition.create! valid_attributes
        put :update, {:id => definition.to_param, :definition => valid_attributes}, valid_session
        expect(assigns(:definition)).to eq(definition)
      end

      it "redirects to the definition" do
        definition = Definition.create! valid_attributes
        put :update, {:id => definition.to_param, :definition => valid_attributes}, valid_session
        expect(response).to redirect_to(word)
      end
    end

    context "with invalid params" do
      it "assigns the definition as @definition" do
        definition = Definition.create! valid_attributes
        put :update, {:id => definition.to_param, :definition => invalid_attributes}, valid_session
        expect(assigns(:definition)).to eq(definition)
      end

      it "re-renders the 'edit' template" do
        definition = Definition.create! valid_attributes
        put :update, {:id => definition.to_param, :definition => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested definition" do
      definition = Definition.create! valid_attributes
      expect {
        delete :destroy, {:id => definition.to_param}, valid_session
      }.to change(Definition, :count).by(-1)
    end

    it "redirects to the definitions list" do
      definition = Definition.create! valid_attributes
      delete :destroy, {:id => definition.to_param}, valid_session
      expect(response).to redirect_to(definitions_url)
    end
  end

end
