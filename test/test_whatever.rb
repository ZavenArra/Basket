
require 'rubygems'
require 'couch_potato'
require 'test/unit'
require 'shoulda'
require_relative '../lattice/lib/lattice/lattice.rb'
require_relative '../models/document.rb'


class TestLattice < Test::Unit::TestCase

  CouchPotato::Config.database_name = "documents"

  context 'basket' do
    should 'work' do
    end
  end

  context 'document' do
    should 'save new' do
      document = Document.new
      CouchPotato.database.save_document document
      CouchPotato.database.destroy_document document
    end
    should 'save new configured type' do
      document = Document.newWithType('textOnly')
      CouchPotato.database.save_document document
      CouchPotato.database.destroy_document document
    end
    should 'update field' do
      document = Document.newWithType('textOnly')
      CouchPotato.database.save_document document
      document.title = 'new title'
      CouchPotato.database.save_document document
      CouchPotato.database.destroy_document document
    end

    should 'update non title field' do
      document = Document.newWithType('textOnly')
      CouchPotato.database.save_document document
      document.textOne = 'new Text only'
      CouchPotato.database.save_document document
      CouchPotato.database.destroy_document document
    end

    should 'load dynamic fields' do
      document = Document.newWithType('article')
      CouchPotato.database.save_document document
      id = document.id
      document = CouchPotato.database.load_document id
      CouchPotato.database.destroy_document document
    end

    should "save checkbox fields" do
      document = Document.newWithType('checkbox')
      CouchPotato.database.save_document document
      id = document.id
      document = CouchPotato.database.load_document id
      document.createProperties #hack
      document.checkboxen = '1'
      document.title ='MIN'
      CouchPotato.database.save_document document
    end

  end

end
