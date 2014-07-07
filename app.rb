require "sinatra"
require "rack-flash"

require "./lib/user_database"
require "./lib/fish_database"
class App < Sinatra::Application

  enable :sessions
  use Rack::Flash

  def initialize
    super
    @user_database = UserDatabase.new
    @fish_database = FishDatabase.new

  end

  get "/" do
    id = session[:id]
    if id
      erb :loggedin, :locals => {:users => display_users(id), :cur_user => @user_database.find(id)[:username], :fish => display_fish(id)}
    else
      erb :loggedout
    end
  end

  get "/register" do
    erb :register
  end

  post "/register" do
    check_reg(params[:username], params[:password])
  end

  post "/" do
    check_login(params[:username], params[:password])
  end

  get "/logout" do
    session.delete(:id)
    redirect "/"
  end

  delete "/:id" do
    id = params[:id].to_i
    flash[:notice] = "#{@user_database.find(id)[:username]} deleted"
    @user_database.delete(id)
    redirect "/"
  end

  get "/new_fish" do
    erb :new_fish
  end

  post "/new_fish" do
    @fish_database.insert(:name => params[:fish_name],
                          :author => session[:id],
                          :wiki => "http://en.wikipedia.org/wiki/#{params[:fish_name]}"
                          )
    redirect "/"
  end

  get "/:user" do
    erb :user, :locals => {:name => params[:user], :fish => display_fish(get_id(params[:user]))}
  end

  delete "/fish/:id" do
    id = params[:id].to_i
    flash[:notice] = "#{@fish_database.find(id)[:name]} deleted"
    @fish_database.delete(id)
    redirect "/"
  end

  private

  def check_login(username, password)
    if username == '' && password == ''
      flash[:notice] = "Username and password is required"
    elsif username == ''
      flash[:notice] = "Username is required"
    elsif password == ''
      flash[:notice] = "Password is required"
    elsif !get_id(username)
      flash[:notice] = "Not a registered user"
    elsif get_id(username) and !check_pw(password)
      flash[:notice] = "Invalid password"
    else
      session[:id] = get_id(username)
    end
    redirect "/"
  end

  def check_reg(username, password)
    if username == ""
      flash[:notice] = "Please enter a username"
      redirect "/register"
    elsif password == ""
      flash[:notice] = "Please enter a password"
      redirect "/register"
    elsif @user_database.all.select { |user| user[:username] == username } == []
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
    val_users = @user_database.all.select {|user| user[:username] == username}
    if val_users != []
      val_users[0][:id]
    end
  end

  def check_pw(password)
    pw = @user_database.all.select {|user| user[:password] == password}
    if pw != []
      pw
    end
  end

  def display_fish(id)
    @fish_database.all.select {|fish| fish[:author] == id}
  end

end
