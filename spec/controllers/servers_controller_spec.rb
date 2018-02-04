require 'rails_helper'

RSpec.describe ServersController, type: :controller do
  describe '#index' do
    context 'with no signed in user' do
      it 'should redirect to the login view' do
        get :index
        expect(response).to redirect_to new_user_session_path
      end
    end
    context 'with a signed in user' do
      let(:user) { create :user }
      before do
        sign_in user
      end

      it 'should show the server list view' do
        get :index
        expect(response).to render_template :index
      end
    end

  end

  describe '#show' do
    let(:user) { create(:user) }
    let(:server) { create(:server, stat_count: 3) }

    context 'with no signed in user' do
      it 'should redirect to the login view' do
        get :show, id: server.id
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'with a signed in user' do
      before do
        sign_in user
      end

      it 'should show the server show view' do
        get :show, id: server.id
        expect(response).to render_template :show
      end
    end

  end

  describe '#new' do
    let(:user) { create :user }

    context 'with no signed in user' do
      it 'should redirect to the login view' do
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe '#edit' do

  end

end
