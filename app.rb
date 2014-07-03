require "sinatra"
require "rack-flash"

require "./lib/user_database"

class App < Sinatra::Application

  enable :sessions
  use Rack::Flash

  def initialize
    super
    @user_database = UserDatabase.new
  end

  get "/" do

  erb :homepage
  end

  get "/register" do

  erb :register
  end

  post "/register" do
    check_reg(params[:name], params[:password])
  end

  post "/" do
    check_login(params[:username], params[:password])
  end

  delete "/" do
    id = params[:id].to_i
    flash[:notice] = "#{@user_database.find(id)[:username]} deleted"
    @user_database.delete(id)
    erb :loggedin, :locals => {:users => display_users(session[:id]), :cur_user => @user_database.find(session[:id])[:username]}
  end




  private

  def check_login(username, password)
    if username == '' && password == ''
      flash[:notice] = "Username and password is required"
      redirect "/"
    elsif username == ''
      flash[:notice] = "Username is required"
      redirect "/"
    elsif password == ''
      flash[:notice] = "Password is required"
      redirect "/"
    elsif !get_id(username)
      flash[:notice] = "Not a registered user"
      redirect "/"
    elsif get_id(username) and !check_pw(password)
      flash[:notice] = "Invalid password"
      redirect "/"
    else
      session[:id] = get_id(username)
      erb :loggedin, :locals => {:users => display_users(session[:id]), :cur_user => @user_database.find(session[:id])[:username]}
    end
  end

  def check_reg(username, password)
    if (@user_database.all).select { |user| user[:username] == username } == []
      @user_database.insert(:username => username, :password => password)
      flash[:notice] = "Thank you for registering"
      redirect "/"
    else
      flash[:notice] = "That username is already taken"
      redirect "/register"
    end
  end

  def display_users(id)
    @user_database.all.select {|user| user[:id] != id}
  end

  def get_id(username)
    valid_user = @user_database.all.select {|user| user[:username] == username}
    if valid_user != []
      valid_user[0][:id]
    end
  end

  def check_pw(password)
    pw = @user_database.all.select {|user| user[:password] == password}
    if pw != []
      pw
    end
  end

end
