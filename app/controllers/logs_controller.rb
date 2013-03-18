class LogsController < ApplicationController
  before_filter :authenticate_user!
  def index
    @logs = Log.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @logs }
    end
  end


  def show
    @log = Log.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @log }
    end
  end


  def new
    @log = Log.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @log }
    end
  end


  def edit
    @log = Log.find(params[:id])
  end


  def create
    @log = Log.new(params[:log])
    @log.user = current_user
    respond_to do |format|
      if @log.save
        format.html { redirect_to @log, notice: 'Log was successfully created.' }
        format.json { render json: @log, status: :created, location: @log }
      else
        format.html { render action: "new" }
        format.json { render json: @log.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    @log = Log.find(params[:id])
    @log.user = current_user
    respond_to do |format|
      if @log.update_attributes(params[:log])
        format.html { redirect_to @log, notice: 'Log was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @log.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @log = Log.find(params[:id])
    @log.destroy

    respond_to do |format|
      format.html { redirect_to logs_url }
      format.json { head :no_content }
    end
  end
end
