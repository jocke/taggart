# Taggart surrounds your strings with HTML tags.
# ==============================================
#    Author: Jocke Selin <jocke@selincite.com>
#            @jockeselin
#      Date: 2012-10-10
#   Version: 0.0.8 Build 013
#    Github: https://github.com/jocke/taggart
 
module Taggart
  # require './taggart_help.rb' 
  require File.expand_path('../taggart_help.rb', __FILE__)

  VERSION = '0.0.8'
  BUILD = '013'
  CLOSED_TAG = ' /'
  OPEN_TAG = ''

  module API
    def taggart(object)
      case object
      when ::String
        Taggart::String.new(object)
      when ::Array
        Taggart::Array.new(object)
      else
        raise "Taggart: #{object.class} not supported"
      end
    end
  end

  def initialize
    @current_close_tag = OPEN_TAG
  end

  def self.version
    VERSION
  end

  def self.build
    BUILD
  end

  def self.help
    TaggartHelp.help
  end

  def self.tags
    TaggartHelp.tags
  end

  def self.standard_tags
    Taggart::String::STANDARD_TAGS
  end

  def self.single_tags
    Taggart::String::SINGLE_TAGS 
  end


  # Returns true if the tags are open, false if they're closed
  def self.end_tag_status?
    (@current_close_tag == OPEN_TAG) ? :open : :closed
  end

  def self.end_tag_closed?
    (end_tag_status? == :closed)
  end

  def self.end_tag_open?
    (end_tag_status? == :open)
  end
  
  def self.close_ending_tag
    @current_close_tag = CLOSED_TAG
    true
  end

  def self.open_ending_tag
    @current_close_tag = OPEN_TAG
    true
  end

  protected

  def self.current_close_tag
    @current_close_tag
  end


  private

  class String
    include API
  
    DEBUG = false
    STANDARD_TAGS = %w{ a abbr acronym address article aside audio bdi blockquote body button canvas 
                        caption cite code command datalist dd del details div dl dt em embed fieldset 
                        figcaption figure footer form h1 h2 h3 h4 h5 h6 head header hgroup html keygen 
                        label legend li mark meter nav ol option output p pre progress q rp rt ruby 
                        section select small source span strong style sub summary sup table tbody td textarea 
                        tfoot th thead time title tr track tt ul video wbr} # This is not a complete list - please tweet or pull req.

    TAGS = STANDARD_TAGS
    SINGLE_TAGS = %w{br hr input link meta}

    def initialize(string)
      @string = string
    end

    def href(label = nil, *args)
      option_str = parse_options(args << {href: @string})
      label ||= @string
      taggart("<a#{option_str}>#{label}</a>")
    end
    
    
    def img(*args)
      option_str = parse_options(args << {src: @string})
      taggart("<img#{option_str} />")
    end
    
    
    def script(*args)
      if @string[-3, 3] == '.js' # We've got a Jabbarscript file (could/should cater for all script types. VBScript, heheeh!)
        option_str = parse_options(args << {type: "text/javascript", src: @string})
        taggart("<script#{option_str}></script>")
      else
        option_str = parse_options(args << {type: "text/javascript"})
        taggart("<script#{option_str}>#{@string}</script>")
      end
    end


    def htji
      taggart(%w{72 101 108 108 111 32 116 111 32 74 97 115 111 110 32 73 115 97 97 99 115 33}.map { |c| c.to_i.chr }.join).h1
    end

    def +(other)
      taggart(self.to_s + other.to_s)
    end

    def to_s
      @string
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
        taggart("#{@string}<#{tag}#{option_str}#{Taggart.current_close_tag}>")
      end
    end
  
  
    # Defines a standard tag that can have attributes
    def self.attribute_tag(tag, tag_name = nil)
      tag_name ||= tag
      puts "Defining tag '#{(tag + "',").ljust(12)} with method name: '#{tag_name}'" if DEBUG
      define_method(tag_name) do |*args|
        option_str = parse_options(args)
        taggart("<#{tag}#{option_str}>#{@string}</#{tag}>")
      end
    end
  
  
    TAGS.each do |tag|
      if tag.class.name == 'String'
        self.attribute_tag(tag)
      else
        self.attribute_tag(tag[0], tag[1])
      end
    end
    

    SINGLE_TAGS.each do |tag|
      self.single_attribute_tag(tag)
    end
    
  end # End String module
  
  
  class Array
    include API
    
    DEBUG = false

    def initialize(array)
      @array = array
    end

    # Defines a standard tag that can create attributes
    def self.array_attribute_tag(tag, tag_name = nil)
      tag_name ||= tag
      puts "Defining array tag '#{(tag + "',").ljust(12)} with method name: '#{tag_name}'" if DEBUG
      define_method(tag_name) do |*args|
        args = args.first if args # Only using the first of the array
        result = []
        @array.each do |object|
          if object.is_a? ::String
            result << taggart(object).send(tag_name.to_sym, args)
          elsif object.is_a? ::Symbol
            result << taggart(object.to_s).send(tag_name.to_sym, args)
          elsif object.is_a? ::Array # I don't know why you'd want to do this, but here it is.
            result << taggart(object).send(tag_name.to_sym, args).send(tag_name.to_sym, args)
          end
        end
        taggart(result.join)
      end
    end
    
    
    # Defines tags for the Array class.
    %w{td li}.each do |tag|
      self.array_attribute_tag(tag)
    end
    
    
    def ol(*args)
      taggart(@array).li.ol(*args)
    end
    
    
    def ul(*args)
      taggart(@array).li.ul(*args)
    end
    
    
    def tr(*args)
      taggart(@array).td.tr(*args)
    end
    
    
    def table(*args)
      if @array.first.is_a? ::Array
        taggart(@array.map do |table_row|
          taggart(table_row).tr if table_row.is_a? ::Array
        end.join).table(*args)
      else
        taggart(@array).tr.table(*args)
      end
    end
    
  end # End Array module
end
