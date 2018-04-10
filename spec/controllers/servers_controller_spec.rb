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

    context 'with a signed in user' do
      before do
        sign_in user
      end

      it 'should show the server create page' do
        get :new
        expect(response).to render_template :new
      end
    end
  end

  describe '#update' do
    let(:user) { create(:user) }
    let(:server) { create(:server) }

    before do
      sign_in user
    end
    
    context 'with valid params' do
      let(:attr) { {name: "My Updated Server", hostname: "test-server", port: 5001} }

      it 'should update the server object with new params' do
        put :update, id: server.id, server: attr
        server.reload
        
        expect(response).to redirect_to server_path server.id
        expect(flash[:notice]).to eq "Server was successfully updated."
        expect(server.name).to eq attr[:name]
        expect(server.hostname).to eq attr[:hostname]
        expect(server.port).to eq attr[:port]
      end
    end

    context 'with invalid params' do
      let(:attr) { {name: "My Updated Server", hostname: "test-server", port: nil} }
      
      it 'should not update the server object' do
        put :update, id: server.id, server: attr
        server.reload
        
        expect(server.name).to_not eq attr[:name]
        expect(server.hostname).to_not eq attr[:hostname]
        expect(server.port).to_not eq attr[:port]
      end
    end

  end

  describe '#create' do
    let(:user) { create(:user) }
    let!(:attr) { {name: "My Test Server", hostname: "127.0.0.1", port: 3001} }
    let(:server) { Server.last }

    before do
      sign_in user
    end

    context 'with valid params' do
      let(:attr) { {name: "My Test Server", hostname: "127.0.0.1", port: 3001} }

      it 'should create a server object with params' do 
        expect { post :create, server: attr }.to change(Server, :count).by 1
        expect(response).to redirect_to server_path server.id
        expect(flash[:notice]).to eq "Server was successfully created."
        expect(server.name).to eq attr[:name]
        expect(server.hostname).to eq attr[:hostname]
        expect(server.port).to eq attr[:port]
      end
    end

    context 'with invalid params' do
      let(:attr) { {name: "My Test Server", hostname: "127.0.0.1"} }
      
      it 'should not create a server object' do
        expect { post :create, server: attr }.to_not change(Server, :count)
      end
    end
  end

  describe '#destroy' do
    let(:user) { create(:user) }
    let!(:server) { create(:server) }
    
    before do
      sign_in user
    end

    it 'should delete the server object' do
      expect { delete :destroy, { id: server.id } }.to change(Server, :count).by -1
      expect(flash[:notice]).to eq "Server was successfully destroyed."
    end
  end

end
