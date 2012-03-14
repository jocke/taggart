# Taggart allows you to tag Strings with HTML
# ===========================================
#    Author: Jocke Selin <jocke@selincite.com>
#            @jockeselin
#      Date: 2012-03-14
#   Version: 0.0.6 Build 011
#    Github: https://github.com/jocke/taggart
 
module Taggart
  module String
  
    DEBUG = false
    

    # Redefining <tr> to work with both translate-tr and tag-tr
    def dual_tr(*args)
      if ((args.size == 2) && (args[0].is_a? String) && (args[1].is_a? String))
        self.translate(args[0], args[1])
      else
        self._tr(args.first)
      end
    end


    # Redefining <sub> to work with both substitute-sub and tag-sub
    def dual_sub(*args, &block)
      if (args[0].is_a? Hash)
        self._sub(args.first)
      elsif args.empty?
        self._sub
      else
        if block_given?
          self.substitute(args[0]) { |*args| block.call(*args) }
        else
          self.substitute(args[0], args[1])
        end
      end
    end
    
        
    def href(label = nil, *args)
      option_str = parse_options(args << {href: self})
      label ||= self
      "<a#{option_str}>#{label}</a>"
    end
    
    
    def img(*args)
      option_str = parse_options(args << {src: self})
      "<img#{option_str} />"
    end
    
    
    def script(*args)
      if self[-3, 3] == '.js' # We've got a Jabbarscript file (could/should cater for all script types. VBScript, heheeh!)
        option_str = parse_options(args << {type: "text/javascript", src: self})
        "<script#{option_str}></script>"
      else
        option_str = parse_options(args << {type: "text/javascript"})
        "<script#{option_str}>#{self}</script>"
      end
    end
    
  
    private 
    
  
    # Parses the options for the tags
    def parse_options(args)
      return "" if args.nil?
      output = []
      args.each do |argument|
        if argument.nil? # Do nothing
        elsif argument.is_a? String
          output << " " + argument
        elsif argument.is_a? Hash
          argument.each do |key, value|
            output << "#{key.to_s}=\"#{value}\""
          end
        else
          raise "Argument of type #{argument.class.name} is not implemented"
        end
      end
      return "" if output.empty?
      " " + output.join(' ')
    end
    
    
    # Defines a single tag, such as <br /> or <hr />
    def self.single_attribute_tag(tag)
      define_method(tag) do |*args|
        option_str = parse_options(args)
        "#{self}<#{tag}#{option_str} />"
      end
    end
  
  
    # Defines a standard tag that can have attributes
    def self.attribute_tag(tag, tag_name = nil)
      tag_name ||= tag
      puts "Defining tag '#{(tag + "',").ljust(12)} with method name: '#{tag_name}'" if DEBUG
      define_method(tag_name) do |*args|
        option_str = parse_options(args)
        "<#{tag}#{option_str}>#{self}</#{tag}>"
      end
    end
  
  
    standard_tags = %w{ h1 h2 h3 h4 h5 h6 a title html head table thead tfoot button fieldset form label 
                        select legend option textarea body blockquote q tbody th td tfoot style div
                        span abbr acronym address dd dl dt li ol caption ul em strong p tt pre sup del
                        small cite code } # This is not a complete list - please tweet or pull req.
    special_tags  = [['tr', '_tr'], ['sub', '_sub']]
    tags = standard_tags + special_tags
    tags.each do |tag|
      if tag.class.name == 'String'
        self.attribute_tag(tag)
      else
        self.attribute_tag(tag[0], tag[1])
      end
    end
    
    %w{br hr input link meta}.each do |tag|
      self.single_attribute_tag(tag)
    end
    
  end # End String module
  
  
  module Array
    
    DEBUG = false
    
    
    # Defines a standard tag that can create attributes
    def self.array_attribute_tag(tag, tag_name = nil)
      tag_name ||= tag
      puts "Defining array tag '#{(tag + "',").ljust(12)} with method name: '#{tag_name}'" if DEBUG
      define_method(tag_name) do |*args|
        args = args.first if args # Only using the first of the array
        result = []
        self.each do |object|
          if object.is_a? String
            result << object.send(tag_name.to_sym, args)
          elsif object.is_a? Symbol
            result << object.to_s.send(tag_name.to_sym, args)
          elsif object.is_a? Array # I don't know why you'd want to do this, but here it is.
            result << (object.send(tag_name.to_sym, args)).send(tag_name.to_sym, args)
          end
        end
        result.join
      end
    end
    
    
    # Defines tags for the Array class.
    %w{td li}.each do |tag|
      self.array_attribute_tag(tag)
    end
    
    
    def ol(*args)
      self.li.ol(*args)
    end
    
    
    def ul(*args)
      self.li.ul(*args)
    end
    
    
    def tr(*args)
      self.td.tr(*args)
    end
    
    
    def table(*args)
      if self.first.is_a? Array
        self.map do |table_row|
          table_row.tr if table_row.is_a? Array
        end.join.table(*args)
      else
        self.tr.table(*args)
      end
    end
    
  end # End Array module
end

  
class String
  alias_method :translate, :tr
  alias_method :substitute, :sub
  include Taggart::String

  def tr(*args) 
    dual_tr(*args)
  end
  
  def sub(*args, &block) 
    dual_sub(*args, &block)
  end
end


class Array
  include Taggart::Array
end
