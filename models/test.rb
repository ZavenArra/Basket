
class TestD

  include CouchPotato::Persistence

  # CouchConnect.Model

  #Some of these should be configuratable in the config
  property   :ruby_type

  view :all, :key => :title

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



end
