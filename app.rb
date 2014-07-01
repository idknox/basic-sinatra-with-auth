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
    username = params[:name]
    password = params[:password]

    @user_database.insert(:username=>username, :password=>password)

    flash[:notice] = "Thank you for registering #{@user_database.all}"
    redirect "/"

  end

  post "/" do
    username = params[:username]
    password = params[:password]
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

      erb :loggedin, :locals=>{:username=>username}
    end
  end

end
