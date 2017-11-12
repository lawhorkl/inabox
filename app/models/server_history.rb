class ServerHistory < ApplicationRecord
  belongs_to :server
  after_create :populate_conversions

  def populate_conversions
    %w[gb mb kb].each { |size| eval "self.usage_in_#{size} = convert_to_#{size}" }
    self.save
  end
  
  def convert_usage_to_gb
    self.ram_capacity / (1024*1024*1024)
  end

  def convert_usage_to_mb
    self.ram_capacity / (1024*1024)
  end

  def convert_usage_to_kb
    self.ram_capacity / (1024)
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
