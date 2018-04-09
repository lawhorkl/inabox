class ChartsController < ApplicationController
  
  def server_memory
    render json: ServerHistory.where(server_id: params[:id]).group_by_minute(:created_at).maximum(:usage_in_mb) 
  end

  def server_cpu
    render json: ServerHistory.where(server_id: params[:id]).group_by_minute(:created_at).maximum(:cpu_load_one)
  end

  def server_disk
    render json: ServerHistory.where(server_id: params[:id]).group_by_minute(:created_at).maximum(:disk_percentage)
  end
end
