require_relative '../../lib/goalie/date_util'
class LogsController < ApplicationController

  before_filter :setup_goal

  def setup_goal
    goal_id = params[:goal_id]
    if goal_id
      @goal = Goal.find(goal_id)
    end
  end

  # GET /logs
  # GET /logs.json
  def index
    @logs = @goal.logs.order('log_date DESC')
    @log = Log.new
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @logs }
    end
  end

  # GET /logs/1
  # GET /logs/1.json
  def show
    @log = Log.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @log }
    end
  end

  # GET /logs/new

  # GET /logs/1/edit
  def edit
    @log = Log.find(params[:id])
  end

  # GET /logs/new.json
  def new
    @log = Log.new
    @log.goal = @goal

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @log }
    end
  end

  # POST /logs
  # POST /logs.json
  def create
    @log = Log.new(params[:log])
    @log.goal = @goal
    @logs = @goal.logs

    respond_to do |format|
      if @log.save
        format.html { redirect_to :back, notice: 'Log was successfully created.' }
        format.json { render json: @log, status: :created, location: @log }
      else
        format.html { render action: 'index' }
        format.json { render json: @log.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /logs
  # POST /logs.json
  def create_solo
    @log = Log.new(params[:log])
    @log.goal = @goal

    respond_to do |format|
      if @log.save
        format.html { redirect_to [@goal, @log], notice: 'Log was successfully created.' }
        format.json { render json: @log, status: :created, location: @log }
      else
        format.html { render action: "new" }
        format.json { render json: @log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /logs/1
  # PUT /logs/1.json
  def update
    @log = Log.find(params[:id])
    @logs = @goal.logs

    respond_to do |format|
      if @log.update_attributes(params[:log])
        format.html { redirect_to goal_logs_url(@goal), notice: 'Log was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'index' }
        format.json { render json: @log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /logs/1
  # DELETE /logs/1.json
  def destroy
    @log = Log.find(params[:id])
    @log.destroy

    respond_to do |format|
      format.html { redirect_to goal_logs_url(@goal) }
      format.json { head :no_content }
    end
  end
end
