class GoalsController < ApplicationController
  # GET /goals
  # GET /goals.json
  def index
    @goals = goals_for_current_user
    @goal = Goal.new
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @goals }
    end
  end

  # GET /goals/1
  # GET /goals/1.json
  def show
    @goal = Goal.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @goal }
    end
  end

  # GET /goals/new
  # GET /goals/new.json
  def new
    @goal = Goal.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @goal }
    end
  end

  # GET /goals/1/edit
  def edit
    @goal = Goal.find(params[:id])
  end

  # POST /goals
  # POST /goals.json
  def create
    @goals = current_user.goals
    @goal = Goal.new(params[:goal])
    @goal.user = current_user

    respond_to do |format|
      if @goal.save
        format.html { redirect_to :index, notice: 'Goal was successfully created.' }
        format.json { render json: @goal, status: :created, location: @goal }
      else
        format.html { render action: 'index' }
        format.json { render json: @goal.errors, status: :unprocessable_entity }
      end
    end
  end


  # POST /goals
  # POST /goals.json
  def create_solo
    @goal = Goal.new(params[:goal])
    @goal.user = current_user

    respond_to do |format|
      if @goal.save
        format.html { redirect_to @goal, notice: 'Goal was successfully created.' }
        format.json { render json: @goal, status: :created, location: @goal }
      else
        format.html { render action: 'new' }
        format.json { render json: @goal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /goals/1
  # PUT /goals/1.json
  def update
    @goal = Goal.find(params[:id])

    respond_to do |format|
      if @goal.update_attributes(params[:goal])
        format.html { redirect_to goals_url, notice: 'Goal was successfully updated.' }
        format.json { head :no_content }
      else
        @goals = goals_for_current_user
        format.html { render action: "index" }
        format.json { render json: @goal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /goals/1
  # DELETE /goals/1.json
  def destroy
    @goal = Goal.find(params[:id])
    @goal.destroy

    respond_to do |format|
      format.html { redirect_to goals_url }
      format.json { head :no_content }
    end
  end

private

  def goals_for_current_user
    @goals = current_user.goals.order('start DESC')
  end

end
