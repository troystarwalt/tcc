require 'sinatra'

get '/' do
	@images = gather_phone_data.every_nth(3) #every third starting with the first is an image src
	@makers = gather_phone_data.drop(1).every_nth(3) #every third starting with the second is a maker
	@models = gather_phone_data.drop(2).every_nth(3) #every third starting with the third is a model
	erb :index
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