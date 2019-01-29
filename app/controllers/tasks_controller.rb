class TasksController < ApplicationController
    before_action :set_task, only: [:show, :edit, :update, :destroy]
    before_action :require_user_logged_in
    before_action :correct_user, only: [:show, :edit, :update, :destroy]
  
  def index
    # @tasks = Task.all.page(params[:page]).per(5)
    @tasks = current_user.tasks.page(params[:page]).per(5)
    # @tasks = Task.where(user_id: current_user.id).page(params[:page]).per(5)
  end

  def show
  end

  def new
    # これだと、特定のUserに紐付かないtaskができてしまう
    # @task = Task.new
    # 現在のUserに紐づく空のtaskができる
    @task = current_user.tasks.build
  end

  def create
    @task = current_user.tasks.build(task_params)
    
     if @task.save
      flash[:success] = 'task が正常に投稿されました'
      redirect_to @task
    else
      flash.now[:danger] = 'task が投稿されませんでした'
      render :new
     end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:success] = 'Task は正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Task は更新されませんでした'
      render :edit
    end
  end

  def destroy
    @task.destroy

    flash[:success] = 'Task は正常に削除されました'
    redirect_to tasks_url
  end

 private
  def correct_user
    unless current_user.tasks.find_by(id: params[:id])
      redirect_to root_url
    end
  end
 
  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:content, :status)
  end
end