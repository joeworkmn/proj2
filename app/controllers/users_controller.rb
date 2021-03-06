class UsersController < ApplicationController
  def index
    @users = User.all
  end
  
  def new
  end
  
  def create
    first_name = params[:user][:fname]
    last_name = params[:user][:lname]
    username = params[:user][:uname]
    password = params[:user][:pword]
    division = params[:user][:div]
    department = params[:user][:dep]
    conn = ActiveRecord::Base.connection
    sql = "insert into users_view (first_name,last_name,username,password," +
          "division,department) values ('" + first_name + "','" + last_name + 
          "','" + username + "','" + password + "','" + division + "','" + 
          department + "')"
    conn.insert(sql)
    redirect_to :controller => "users", :action => "index"
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def chooseUser
    @users = User.all
  end 
  def update
    @user = User.find(params[:user][:id])
    if @user.update_attributes(:first_name => params[:user][:first_name], 
      :last_name => params[:user][:last_name], :username => params[:user][:username], 
      :division => params[:user][:division], :department => params[:user][:department])
      redirect_to :controller => "users", :action => "index"
    else
      render :action => "edit"
    end
  end
  
  def resetPass
    fail = params[:fail]
    if fail
      @notice = "Failed to reset password"
    else
      @notice = "Reset a password"
    end   
  end
  
  def updatePass
    username = params[:logininfo][:username]
    password = params[:logininfo][:password]
    conn = ActiveRecord::Base.connection
    result = conn.select_value("select resetPass('" + username + "','" + password + "')")
    if result == "t"
      redirect_to :controller => "users", :action => "resetPassResult"
    elsif result == "f"
      redirect_to :controller => "users", :action => "resetPass", :fail => true
    end
  end
  
  def resetPassResult
    @result = "Password has been changed"
  end

end
