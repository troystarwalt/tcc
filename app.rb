require 'sinatra'
require 'sinatra/base'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'
require './environments'


class Toggle < ActiveRecord::Base
end


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
	if File.exist?('phone_images.txt')
		if Toggle.exists?(1)
			@toggle = Toggle.find(1).toggled
			if @toggle == true
				@images = gather_phone_data.every_nth(3) #every third starting with the first is an image src
				@makers = gather_phone_data.drop(1).every_nth(3) #every third starting with the second is a maker
				@models = gather_phone_data.drop(2).every_nth(3) #every third starting with the third is a model
			end
		end
	end
	erb :index
end

get '/admin' do
	protected!
	unless Toggle.exists?(1)
		toggle = Toggle.create(toggled: true)
		@status = toggle.toggled
	else
		toggle = Toggle.find(1)
		@status = toggle.toggled
	end
	erb :admin, locals: {title: 'admin panel'}
end



post '/hideShowCarousel' do
	status = params[:toggle]['toggleCarousel']
	if status == 'true'
		Toggle.find(1).update(toggled: true)
	elsif status == 'false'
		Toggle.find(1).update(toggled: false)
	else
		flash[:alert] = "There was a problem."
	end
end

post '/scraper' do 
	require './public/scripts/scraper.rb'
	redirect '/admin'
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