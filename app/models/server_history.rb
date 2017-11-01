class ServerHistory < ApplicationRecord
  belongs_to :server
  after_create :populate_conversions

  def populate_conversions
    self.usage_in_gb = convert_to_gb
    self.usage_in_mb = convert_to_mb
    self.usage_in_kb = convert_to_kb
    self.save
  end

  private

  def convert_to_gb
    self.current_ram_usage/(1024*1024*1024)
  end

  def convert_to_mb
    self.current_ram_usage/(1024*1024)
  end

  def convert_to_kb
    self.current_ram_usage/(1024)
  end
end
