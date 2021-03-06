require 'date'

class TasksController < ApplicationController

  #Controller Actions are always methods!
  def index # index means list all
    @tasks = Task.order(:name)
  end

  def show # details of an instance of an object
    task_id = params[:id]
    @task = Task.find_by(id: task_id)

    if @task.nil?
      redirect_to tasks_path # go to the index so we can see the task list
      return
    end
  end

  def update
    @task = Task.find_by(id: params[:id])
    if @task.nil?
      redirect_to tasks_path
      return
    elsif @task.update(task_params)# using strong params

    # elsif @task.update(
    #   name: params[:task][:name],
    #   description: params[:task][:description],
    #   completed_at: params[:task][:completed_at]
    # )
    redirect_to tasks_path # go to the index to verify the task in the list
      return
    else # save failed
      render :edit # show the task form view again
      return
    end
  end

  def edit
    @task = Task.find_by(id: params[:id])
    if @task.nil?
      head :not_found
      return
    end
  end

  def unmark_complete
    @task = Task.find_by(id: params[:id])
    if !@task.complete?
      redirect_to tasks_path 
    else
      @task.update(
        completed_at: nil
      )
      redirect_to tasks_path 
      return
    end
  end

  def mark_complete
    @task = Task.find_by(id: params[:id])
    if @task.complete?
      redirect_to tasks_path 
    else
      @task.update(
        completed_at: Time.now
      )
      redirect_to tasks_path 
      return
    end
  end

  def new 
    @task = Task.new # create a new task
  end

  def create
    # instantiate a new task
    @task = Task.new(task_params)# using strong params
   
    if @task.save # save returns true if the database insert succeeds
      redirect_to task_path(@task.id) # go to the index so we can see the task in the list
      return
    else # save failed 
      render :new # show the new book form view again
      return
    end
  end

  def destroy
    task_id = params[:id] #params is a method returning a hash that uses to access hashes. 
    @task = Task.find_by(id: task_id) # find a task given an id

    if @task.nil?
      redirect_to tasks_path
      return
    else 
      @task.destroy
      redirect_to tasks_path
    end
  end

  private

  def task_params
    return params.require(:task).permit(:name, :description, :completed_at)
  end
  
end
