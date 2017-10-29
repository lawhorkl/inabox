class ServerHistoriesController < ApplicationController
  before_action :set_server_history, only: [:show, :edit, :update, :destroy]

  # GET /server_histories
  # GET /server_histories.json
  def index
    @server_histories = ServerHistory.all
  end

  # GET /server_histories/1
  # GET /server_histories/1.json
  def show
  end

  # GET /server_histories/new
  def new
    @server_history = ServerHistory.new
  end

  # GET /server_histories/1/edit
  def edit
  end

  # POST /server_histories
  # POST /server_histories.json
  def create
    @server_history = ServerHistory.new(server_history_params)

    respond_to do |format|
      if @server_history.save
        format.html { redirect_to @server_history, notice: 'Server history was successfully created.' }
        format.json { render :show, status: :created, location: @server_history }
      else
        format.html { render :new }
        format.json { render json: @server_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /server_histories/1
  # PATCH/PUT /server_histories/1.json
  def update
    respond_to do |format|
      if @server_history.update(server_history_params)
        format.html { redirect_to @server_history, notice: 'Server history was successfully updated.' }
        format.json { render :show, status: :ok, location: @server_history }
      else
        format.html { render :edit }
        format.json { render json: @server_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /server_histories/1
  # DELETE /server_histories/1.json
  def destroy
    @server_history.destroy
    respond_to do |format|
      format.html { redirect_to server_histories_url, notice: 'Server history was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_server_history
      @server_history = ServerHistory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def server_history_params
      params.require(:server_history).permit(:server_id, :name, :hostname, :port, :ram_capacity, :current_ram_usage, :free_ram, :cores_available, :current_core_usage)
    end
end
