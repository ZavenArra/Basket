require 'rexml/document'
require 'erb'
require 'pathname'

module Lattice 


  def Lattice.buildUIForDocumentType(type, values=nil)
    xml = REXML::Document.new(File.open("objects.xml"))
    #p xml.elements.each("//objectType") { |t| puts t.attributes["name"] }

    objectTypesXPath = "//objectType[@name='"+type+"']"
    objectType = xml.elements[objectTypesXPath]
    if !objectType
      raise "Object type not found: " + article
    end
    #p objectType.attributes["name"]
    #need to get the object type from object here

    ui = ""
    elementsXPath = "elements/*"
    objectType.elements.each(elementsXPath) do |uiElement|
      elementui = Lattice::ElementUI.new(uiElement.name, uiElement.attributes, nil)
      ui += elementui.render()
    end

    p ui

  end


  #will need an elementUI for each type of UI
  class ElementUI

    def initialize(type, attributes, value)
      viewName = "ui_"+type
      view_dir = Pathname.new(File.dirname(__FILE__))+'../views/'
      view_file = viewName+".erb"
      @view = ERB.new(File.open(view_dir+view_file).read)
      @value = value
      @label = attributes['label']
      @name = attributes['name']
    end

    def render
      @view.result(binding) 
    end

  end

end




