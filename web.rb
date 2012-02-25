require 'rubygems'
require 'sinatra'
require 'couch_potato'
require_relative 'lattice/lib/lattice/lattice.rb'
require_relative 'models/document.rb'
require_relative 'models/test.rb'
require 'sinatra/logger'


CouchPotato::Config.database_name = "documents"

get '/' do

  @documents = CouchPotato.database.view Document.allByUpdated(:descending => true)
 # @documents.each() do |d|
 #   CouchPotato.database.destroy_document d
 # end
 # @documents = nil
  @docTypes = Lattice::getDocumentTypes()
  erb :basket
end

post '/addDocument' do

  document = Document.new(params['lattice_document_type'])
  document.title = params[:title]
  if params[:lattice_document_type] 
    document.lattice_document_type = params[:lattice_document_type]
  end
  CouchPotato.database.save_document document
  jData = Hash[ "id"=>document.id, "title"=>document.title] 
  jData.to_json
  redirect to('/'+document.id)
  #redirect to('/')

end


get '/:id' do |id|
  document = CouchPotato.database.load_document id
  @content = Lattice::buildUIForDocumentType(document.lattice_document_type, document)
  @documentId = id
  erb :document
end

delete '/:id' do |id|

end

post '/saveField/:id' do |id|
  document = CouchPotato.database.load_document id
  document.send "#{params[:field]}=", params[:value]
  CouchPotato.database.save_document document
  savedValue = document.send "#{params[:field]}"
  jData = {'returnValue'=>true, 'response'=>{'value'=>savedValue}, 'params'=>params}
  jData.to_json
end

get '/togglePublish/:id' do |id|

end


get '/hi' do
	  "Hello Vorld!"
end

