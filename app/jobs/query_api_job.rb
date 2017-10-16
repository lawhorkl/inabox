class QueryApiJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    byebug
  end
end
