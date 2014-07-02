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
    check_user(params[:name], params[:password])
  end

  post "/" do
    check_input(params[:username], params[:password])
  end

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
    else
      erb :loggedin, :locals => {:username => username}
    end
  end

  def check_user(username, password)
    if (@user_database.all).select { |user| user[:username] == username } == []
      @user_database.insert(:username => username, :password => password)
      flash[:notice] = "Thank you for registering"
      redirect "/"
    else
      flash[:notice] = "That username is already taken"
      redirect "/register"
    end
  end

end
