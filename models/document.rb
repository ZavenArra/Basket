
class Document

  include CouchPotato::Persistence

  # CouchConnect.Model

  #Some of these should be configuratable in the config
  property   :title
  property   :lattice_document_type

  view :all, :key => :title
  view :allByUpdated, :key => :updated_at

  define_model_callbacks :save
 # validates :url, :presence => true

  def create_method( name, &block )
    self.class.send( :define_method, name, &block )
  end

  def create_attr( name )
    create_method( "#{name}=".to_sym ) { |val| 
      instance_variable_set( "@" + name, val)
    }

    create_method( name.to_sym ) { 
      instance_variable_get( "@" + name ) 
    }
  end

  def Document::newWithType(type)
    document = Document.new()
    document.lattice_document_type = type
    document.createProperties
    document
  end


  def createProperties
    p self.lattice_document_type
    attributes = Lattice::getAttributesForDocumentType(self.lattice_document_type)

    #Create accessors
    attributes.each do |name|
      Document.property name.to_sym
    end

  end

  def [](key)
    send(key)
  end

end
