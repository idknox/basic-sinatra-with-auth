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
    erb :loggedin, :locals=>{:username=>username}
  end
end

def check_user(username, password)
  if (@user_database.all).select{|user| user[:username] == username} == []
    @user_database.insert(:username=>username, :password=>password)
    flash[:notice] = "Thank you for registering" #{@user_database.all}
    redirect "/"
  else
    flash[:notice] = "That username is already taken"
    redirect "/register"
  end
end