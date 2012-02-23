require 'sinatra'
require_relative 'lattice/lib/lattice/lattice.rb'

get '/' do
  erb :bucket
end

get '/:id' do |id|
  @content = Lattice::buildUIForDocumentType('textOnly')
  erb :layout #{ puts @content }
end

post '/addObject' do |id|

end

delete '/:id' do |id|

end

post '/saveField/:id' do |id|
  params[:field]
  params[:value]
end

post '/saveFile/:id' do |id|
  params[:field]
  params[:value]
end

get '/togglePublish/:id' do |id|

end


get '/hi' do
	  "Hello Vorld!"
end

