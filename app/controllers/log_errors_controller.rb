class LogErrorsController < ApplicationController

  def index
    @log_errors = LogError.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @log_errors }
    end
  end


  def show
    @log_error = LogError.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @log_error }
    end
  end


  def new
    @log_error = LogError.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @log_error }
    end
  end


  def edit
    @log_error = LogError.find(params[:id])
  end


  def create
    @log_error = LogError.new(params[:log_error])
    @log_error.log_key = params[:log_key] if params[:log_key].present?
    respond_to do |format|
      if @log_error.save
        format.html { redirect_to @log_error, notice: 'Log error was successfully created.' }
        format.json { render json: @log_error, status: :created, location: @log_error }
      else
        format.html { render action: "new" }
        format.json { render json: @log_error.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    @log_error = LogError.find(params[:id])

    respond_to do |format|
      if @log_error.update_attributes(params[:log_error])
        format.html { redirect_to @log_error, notice: 'Log error was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @log_error.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @log_error = LogError.find(params[:id])
    @log_error.destroy

    respond_to do |format|
      format.html { redirect_to log_errors_url }
      format.json { head :no_content }
    end
  end
end
