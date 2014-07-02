require "sinatra"
require "rack-flash"

require "./lib/user_database"
require "./lib/methods.rb"

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

end
