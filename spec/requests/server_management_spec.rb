require 'rails_helper'

RSpec.describe "Server management", type: :request do

  context 'with no signed in user' do

  end

  context 'with a signed in user' do
    let(:user) { create(:user) }
    before do
      sign_in user
    end
    
    it 'creates a server and redirects to the show page' do
      get '/servers/new'

      expect(response).to render_template(:new)

      post '/servers', server: attributes_for(:server)

      expect(response).to redirect_to(assigns(:server)
			follow_redirect!

			expect(response).to render_template(:show)
			

    end

  end
end
