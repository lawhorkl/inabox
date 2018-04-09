require 'rails_helper'

RSpec.describe ChartsController, type: :controller do
  let(:server) { create(:server) }

  describe "#server_memory" do
    it "renders the json necessary to display the memory chart" do
      get :server_memory, params: { id: server.id }

      expect(response).to be_success
    end
  end
  
  describe "#server_cpu" do
    it "renders the json necessary to display the cpu chart" do
      get :server_cpu, params: { id: server.id }

      expect(response).to be_success
    end
  end
  
  describe "#server_disk" do
    it "renders the json necessary to display the disk chart" do
      get :server_disk, params: { id: server.id }

      expect(response).to be_success
    end
  end
end
