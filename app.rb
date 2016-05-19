require 'sinatra'
require 'sinatra/base'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'
require './environments.rb' #sets up postgres db

helpers do
	def title
		@title ? "TCC, Verizon Wireless of Great Neck Premium Retailer - " + @title : "TCC, Verizon Wireless of Great Neck Premium Retailer"
	end 
	def protected!
		return if authorized?
		headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
		halt 401, "Not authorized\n"
	end

	def authorized?
		user = ENV['TCC_USERNAME']
		pass = ENV['TCC_PASSWORD']
		@auth ||=  Rack::Auth::Basic::Request.new(request.env)
		@auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == [user, pass]
	end
end

get '/' do
	@images = gather_phone_data.every_nth(3) #every third starting with the first is an image src
	@makers = gather_phone_data.drop(1).every_nth(3) #every third starting with the second is a maker
	@models = gather_phone_data.drop(2).every_nth(3) #every third starting with the third is a model
	erb :index
end

get '/admin' do
	protected!
	erb :admin, locals: {title: 'admin panel'}
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