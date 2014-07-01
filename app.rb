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
    flash[:notice] = "Thank you for registering"
    redirect "/"
  end

  post "/" do
  username = params[:username]

  erb :loggedin, :locals=>{:username=>username}
  end

end
