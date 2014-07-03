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

  before do

  end
  get "/" do

  erb :homepage
  end

  get "/register" do

  erb :register
  end

  post "/register" do
    check_user(params[:name], params[:password])
  end

  post "/" do
    check_input(params[:username], params[:password])
  end

  # delete "/" do
  # name = params[:name]
  #
  # flash[:notice] = "#{name}"




  private

  def check_input(username, password)
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
      erb :loggedin, :locals => {:users => display_users(username), :cur_user => username}
    end
  end

  def check_user(username, password)
    if (@user_database.all).select { |user| user[:username] == username } == []
      user = @user_database.insert(:username => username, :password => password)
      flash[:notice] = "Thank you for registering"
      redirect "/"
    else
      flash[:notice] = "That username is already taken"
      redirect "/register"
    end
  end

  def display_users(cur_user)
    @user_database.all.select {|user| user[:username] != cur_user}
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
