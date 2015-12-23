require "sinatra"
require "sinatra/activerecord"
require "./models.rb"

set :database, "sqlite3:myblogdb.sqlite3"
enable :sessions


get '/' do 
	#Check to see if there is a current user signed in
	@user = current_user
	#If there is a user...it will do all this stuff and go to the home page
	if @user
	@posts=Post.all
	if @posts.empty?
		var = 1
	else
		var = @posts.last.id + 1
	end
	#Create a new post each time the page is loaded
	Post.create(title: "Post #{var}", body: "This is post #{var}")
	erb :home
	else
		#If no user is signed in, automatically go to sign in page
		redirect '/sign-in'
	end
end

get '/post' do 
	@last_post = Post.last
	erb :post
end


get '/sign-in' do
	erb :signin
end


post '/sign-in' do
#Finds the specific user with the username entered. The .where method will return an array and we need to say .first in order to access one specific record to work with
	@user = User.where(username: params[:username]).first
	#If the user exists AND the user password matches the password from the params
	if @user && @user.password == params[:password]
		#sign the user in
		session[:user_id] = @user.id
		redirect '/'
	else 
		#sign in doesn't work
		redirect '/sign-in'
	end
end


def current_user     
	# If someone is logged in...
	if session[:user_id]      
	# Establish who the current user is
		@current_user = User.find(session[:user_id])     
 	end   
end


get "/logout" do
	session.clear
	redirect "/sign-in"
end

