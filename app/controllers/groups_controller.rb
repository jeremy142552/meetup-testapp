class GroupsController < ApplicationController
  require 'csv'

  def index
    @groups = Group.all
    @organizers = User.organizer
  end
  
  def new
    @group = Group.new
  end
  
  def create
    @group = Group.new(group_params)
  
    if @group.save
      redirect_to groups_path, notice: 'Group created successfully.'
    else
      render :new
    end
  end

  def show
    @group = Group.find(params[:id])
    @users = @group.users
  end

  def edit
    @group = Group.find(params[:id])
  end
  
  def update
    @group = Group.find(params[:id])
  
    if @group.update(group_params)
      redirect_to group_path(@group), notice: 'Group updated successfully.'
    else
      render :edit
    end
  end

  def destroy
    @group = Group.find(params[:id])
    if @group.destroy
      redirect_to groups_path, notice: 'Group deleted successfully.'
    end
  end

def import_users
  uploaded_file = params[:file]
  
  begin
    CSV.foreach(uploaded_file.path, headers: true) do |row|
      group = Group.find_or_create_by(name: row['Group Name'])
      user = User.create(
        first_name: row['First Name'],
        last_name: row['Last Name'],
        group: group,
        role: row['Role in Group']
      )
    end

    redirect_to groups_path, notice: 'Users imported successfully.'
  rescue CSV::MalformedCSVError => e
    redirect_to groups_path, alert: 'Error: Invalid CSV file. Please check the file format and encoding.'
  end
end

  

  private

  def group_params
    params.require(:group).permit(:name)
  end
end
