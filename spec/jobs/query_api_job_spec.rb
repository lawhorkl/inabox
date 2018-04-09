require 'rails_helper'

RSpec.describe QueryApiJob, type: :job do
  include ActiveJob::TestHelper
  
  let!(:server) { create(:server, port: 3001) }
  subject(:job) { described_class.perform_later(server.id) }

  before do
    allow(Server).to receive(:find).with(server.id).and_return(server)
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  it 'queues the job' do
    expect { job }.to have_enqueued_job(described_class)
      .with(server.id).on_queue("default")
  end

  it 'executes the perform method' do
    expect(Server).to receive(:find).with(server.id)

    perform_enqueued_jobs { job }
  end
end
