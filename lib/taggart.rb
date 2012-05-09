# Taggart allows you to tag Strings with HTML
# ===========================================
#    Author: Jocke Selin <jocke@selincite.com>
#            @jockeselin
#      Date: 2012-05-09
#   Version: 0.0.7 Build 012
#    Github: https://github.com/jocke/taggart
 
module Taggart

  VERSION = '0.0.7'
  BUILD = '012'

  def self.help
    puts "Welcome to Taggart (#{VERSION} Build #{BUILD})"
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    puts "Taggart is a library that allows you to easily"
    puts "turn a string (or array) into an HTML tag or more tags"
    puts "by simply calling the 'tag-method' on the string."
    puts "Examples:"
    puts "  'Hello World!'.h1  -->  <h1>Hello World!</h1>'"
    puts "  'Important'.span(class: :important) " 
    puts "                     --> <span class=\"important\">Important</span>"
    puts "  'Break'.br         --> Break<br />"
    puts "  %w(a b c).ul       --> <ul><li>a</li><li>b</li><li>c</li></ul>"
    puts "\nFor a list of tags run Taggart.tags"
    puts "Other informational stuff:"
    puts "  - Version:  Taggart::VERSION"
    puts "  - Build:    Taggart::BUILD"
    puts "\nPlease note that Taggart is considered 'experimental' (but"
    puts "fairly stable) and in early development, so please help make"
    puts "Taggart better; send suggestions, bug fixes, improvements, etc"
    puts "to the author, and do fork the code and send pull requests if"
    puts "you've made an improvement - Thanks!"
    puts "\n\nAuthor: Jocke Selin <jocke@selincite.com> @jockeselin"
  end

  def self.info
    self.help
  end

  def self.tags
    puts "Taggart's tags:"
    puts "~~~~~~~~~~~~~~~"
    puts "This is a list of the tags that Taggart can generate, for your pleasure"
    puts "\nStandard tags:"
    puts "--------------"
    puts "These tags have a start- and end-tag and the take any number of"
    puts "attributes in the form of a hash with key-value pairs."
    output_tags(Taggart::String::STANDARD_TAGS)
    puts "\nSpecial tags"
    puts "------------"
    puts "These tags behave like the Standard tags, but there's already a"
    puts "method defined for the String instance so these tags have to be"
    puts "treated in a slightly special way, in that the tag that's ouputted"
    puts "doesn't have the same method name. I.e to output <tr> you call '._tr'"
    puts "however, you don't really need to bother with knowing this as Taggart"
    puts "does some magic behind the scenes to determine wheter you are asking"
    puts "for a Taggart tag or the original method."
    Taggart::String::SPECIAL_TAGS.sort.each do |tag_pair|
      puts "  Tag: #{('<' + tag_pair[0] + '>').ljust(6)}  Method: .#{tag_pair[1]}"
    end
    puts "\nSingle Tags"
    puts "-------------"
    puts "Single tags are tags that do not an end tag, <br> is one such tag"
    puts "In Taggart Single Tags behave just like Standard tags; you can"
    puts "add attributes to them."
    output_tags(Taggart::String::SINGLE_TAGS)
    puts "\nSmart Tags"
    puts "------------"
    puts "These tags go to the gifted class and can speak elvish. They know what"
    puts "you want from them. They don't behave like the other ones in the sense"
    puts "that you have a string that you want to turn into something, not just a"
    puts "simple tag."
    puts "Here's the pupils of the gifted class:"
    puts ".img    - Turns a URL to an image into an img tag."
    puts ".href   - turns a URL into the href-portion of an A-tag, takes the link"
    puts "          content as a parameter, and also other attributes as 2nd argument."
    puts ".script - Either turns a URL to a script file into a <script src..></script>"
    puts "          tag, or embeds a script source in <script></script> tags. Smart!"
    puts "\nArray tags"
    puts "----------"
    puts "The Array Tags generate HTML tags out of a list of strings in an array."
    puts "For example, you can turn an array into list items by callin the .li-"
    puts "method on the array."
    puts "You can also pass attributes to the tags as with the Standard Tags"
    puts "The tags are:"
    puts "   td        li"
    puts "\nSmart Array Tags"
    puts "-----------------"
    puts "The Smart Array Tags are all a bit more smartly dressed than the"
    puts "proletarian Array Tags. Namely, they figure out what you do."
    puts "Here's the honour roll"
    puts "Method   Tag   Special powers"
    puts ".ol    - Turns an array into an ordered list, wrapping the array elements"
    puts "         in <li> tags so you get your awesome list in one go"
    puts ".ul    - The almost identical twin of .ol"
    puts ".tr    - Like .ol and .li, but wraps the array in <tr> tags with every"
    puts "         element wrapped in a <td> tag."
    puts ".table - The smartest of them all. Creates a complete table from a, one or"
    puts "         two dimensional Array. Each array is wrapped in the <tr> tag with"
    puts "         every element in the Array in <td> tags. It's all finished off"
    puts "         with a decoration of <table>."
    puts "\nTag arrays and methods"
    puts "----------------------"
    puts "You can access the following arrays and methods containing the tags."
    puts "Tags           Array                            Method"
    puts "Standard tags  Taggart::String::STANDARD_TAGS   Taggart.standard_tags"
    puts "Special tags   Taggart::String::SPECIAL_TAGS    Taggart.special_tags"
    puts "Single tags    Taggart::String::SINGLE_TAGS     Taggart.single_tags"
  end


  def self.standard_tags
    Taggart::String::STANDARD_TAGS
  end

  def self.special_tags
    Taggart::String::SPECIAL_TAGS
  end

  def self.single_tags
    Taggart::String::SINGLE_TAGS 
  end


  private

  def self.output_tags(tags)
    columns = 4
    padding = 14
    
    print "  "
    tags.sort.each_with_index do |tag, index| 
      index += 1
      print "#{tag.ljust(padding)}" 
      print "\n  " if ((index % columns) == 0) and (index > 0)
    end
    puts "\n\n"
  end

  module String
  
    DEBUG = false
    STANDARD_TAGS = %w{ h1 h2 h3 h4 h5 h6 a title html head table thead tfoot button fieldset form label 
                        select legend option textarea body blockquote q tbody th td tfoot style div
                        span abbr acronym address dd dl dt li ol caption ul em strong p tt pre sup del
                        small cite code } # This is not a complete list - please tweet or pull req.
    SPECIAL_TAGS  = [['tr', '_tr'], ['sub', '_sub']]
    TAGS = STANDARD_TAGS + SPECIAL_TAGS
    SINGLE_TAGS = %w{br hr input link meta}

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
