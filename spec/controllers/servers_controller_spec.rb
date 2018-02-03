require 'rails_helper'

RSpec.describe ServersController, type: :controller do
  describe '#index' do
    context 'with no signed in user' do
      it 'should redirect to the login page' do
        get :index
        expect(response).to redirect_to new_user_session_path
      end
    end
    context 'with a signed in user' do
      let(:user) { create(:user) }
      before do
        sign_in user
      end

      it 'should show the server listing page' do
        get :index
        expect(response).to render_template(:index)
      end
    end

  end

  describe '#show' do
    

  end

  describe '#new' do

  end

  describe '#edit' do

  end

end
