require 'rubygems'
require 'rexml/document'
require 'erb'
require 'pathname'

module Lattice 

  @xml = nil
  @elementsXPath = "elements/*"

  def Lattice.getDocumentTypes()
    xml = Lattice::getXML
    objectTypesXPath = "//objectType"
    objectTypes = xml.elements[objectTypesXPath]
    types = []
    xml.elements.each(objectTypesXPath) do |t|
      types << t.attributes['name']
    end
    types
  end 

  def Lattice.buildUIForDocumentType(type, values=nil)
    xml = Lattice::getXML
    #p xml.elements.each("//objectType") { |t| puts t.attributes["name"] }

    p type
    objectTypesXPath = "//objectType[@name='"+type+"']"
    objectType = xml.elements[objectTypesXPath]
    if !objectType
      raise "Object type not found: " + type
    end
    #p objectType.attributes["name"]
    #need to get the object type from object here

    ui = ""
    objectType.elements.each(@elementsXPath) do |uiElement|
      if(values)
        value = values[uiElement.attributes['name']]
      else 
        value = nil
      end
      p 'ElementUI'+uiElement.name.capitalize
      elementUIClass = Lattice.const_get('ElementUI'+uiElement.name.capitalize)
      p elementUIClass
      elementui = elementUIClass.new(uiElement.name, uiElement.attributes, value )
      ui += elementui.render()
    end

    p ui

  end

  def Lattice.getAttributesForDocumentType(type)
    xml = Lattice::getXML
    objectTypesXPath = "//objectType[@name='"+type+"']"
    objectType = xml.elements[objectTypesXPath]

    attributes = Array.new
    objectType.elements.each(@elementsXPath) do |uiElement|
      attributes <<  uiElement.attributes['name']
    end
    attributes

  end 

  def Lattice.getXML
    if !@xml
      @xml = REXML::Document.new(File.open("objects.xml"))
    end
    return @xml
  end


  #will need an elementUI for each type of UI
  module ElementUI

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

  class ElementUIText
    extend ElementUI
    include ElementUI

    def initialize(type, attributes, value)
      super type, attributes, value
      @isMultiline = attributes['isMultiline']
    end

  end


  class ElementUICheckbox
    extend ElementUI
    include ElementUI
  end

end




