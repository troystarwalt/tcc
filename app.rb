require 'sinatra'
require 'sinatra/base'
require 'sinatra/activerecord'
# require 'rack-flash'
require 'sinatra/flash'

set :database, 'sqlite3:tcc.sqlite3'

enable :sessions
# use Rack::Flash, :sweep => true
set :sessions => true

helpers do
  def current_user
    session[:user_id].nil? ? nil : User.find(session[:user_id])
  end
end

get '/' do
	@images = gather_phone_data.every_nth(3) #every third starting with the first is an image src
	@makers = gather_phone_data.drop(1).every_nth(3) #every third starting with the second is a maker
	@models = gather_phone_data.drop(2).every_nth(3) #every third starting with the third is a model
	erb :index
end

get '/login' do
	erb :login
end

post '/sign_in' do
  @user = User.where(params[:user]).first
  if @user && @user.password == params[:password]
    flash[:notice] = "You've successfully signed in."
    session[:user_id] = @user.id
    redirect '/sign_up'
  else
    flash[:alert] = "Sorry, there was a problem signing in."
    redirect '/'
  end
end

def gather_phone_data
	lines = File.readlines('phone_images.txt')#opens file in read/write mode
	#lines have '\n' appended to them
	lines.map{|l| l.chomp}#chomps off '/n'
end

class Array
	def every_nth(n)
		select {|x| index(x) % n == 0}
	end
end