# Taggart is a proof-of-concept to "decorate" strings with HTML tags.
# ===================================================================
# Background:
# It's not particularly nice to write "<strong>#{my_variable}</strong>" when
# One could simply write my_variable.strong. The more complex the Ruby code
# is, the nicer it is to not have ", #, { or } soiling the code.
# 
# 
# Playtime:
#   Install the gem:
#     gem install ./Taggart-0.0.1.gem
#   or 
#     gem install taggart       (Not possible yet!)
#   Then load Taggart with:
#     require 'taggart'
#   Taggart is now active, which means you can play around.
#   Try: 
#     "Hello World".h1
#   Or (typographically bad taste): 
#     "Important".em.strong
#   Or do some proper nesting:
#     ("Label".td + "Value".td)._tr.table
#   Add attributes
#     "hello".span(class: 'stuff', id: 'thing')
#   How about a table using arrays?:
#      (%w(r1c1 r1c2 r1c3).td.tr + %w(r2c1 r2c2 r2c3).td.tr).table
#   We can also do single tags.
#      "Gimme a".br
# 
# Issues:
#  - "hello"._sub('world', 'world') returns 
#       "<sub  world  world>hello</sub>"
#      Not really perfect
# 
# Future??? (with your blessing)
#  - Package it into a gem
#  - Send to GitHub
#  - Extending to other HTML elements. "/images/company_logo.jpg".img (could check file, size, etc.)
#                                      "/pages/about_us.html".href
# 
# History
#  - Pushed code to Git.
#  - Created test Gem.
#  - Added files to create Gem and reorganised the file structure.
#  - Made dual_sub pass all the tests, and added the examples from .tr (translate) Ruby docs to the test.
#  - More work on the "dynamic namespace clash resolver", in other words, tr and sub work in both classic and Taggart way.
#  - Initial version of "dynamic namespace clash resolver" to fix issues with .tr
#  - Added basic RSpec test.
#  - Added namespacing for Strings and Arrays
#  - Implemented arrays; ["Label", "Value"].td.tr.table and ["First", "Second", "Third"].li.ol
#  - Tidied up things a bit.
#  - Added a version of attributes ("Red".span(class: 'red'))
#  - First version. Basic tags.
# 
# Feedback welcome!!
# 
#    Author: Jocke Selin <jocke@selincite.com>
#      Date: 2012-02-16
#   Version: 0.0.1 Build 007
#
 
module Taggart
  module String
  
    DEBUG = false

    # Redefining <tr> to work with both translate-tr and tag-tr
    def dual_tr(*args)
      puts "Args size: #{args.size}" if DEBUG
      if ((args.size == 2) && (args[0].is_a? String) && (args[1].is_a? String))
        puts "Send '#{args[0]}', '#{args[1]}' to translate-tr" if DEBUG
        self.translate(args[0], args[1])
      else
        puts "Send to tag-tr" if DEBUG
        self._tr(args.first)
      end
    end


    # Redefining <sub> to work with both substitute-sub and tag-sub
    def dual_sub(*args, &block)
      puts "Args size: #{args.size}" if DEBUG
      if (args[0].is_a? Hash)
        puts "Send to tag-sub" if DEBUG
        self._sub(args.first)
      elsif args.empty?
        self._sub
      else
        puts "Send '#{args[0]}', '#{args[1]}' to substitute-sub" if DEBUG
        if block_given?
          self.substitute(args[0]) { |*args| block.call(*args) }
        else
          self.substitute(args[0], args[1])
        end
      end
    end
    
  
    private 
  
    # Parses the options for the tags
    def parse_options(args)
      # puts "parse_options: args #{args.inspect})" if DEBUG
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
          puts "Argument of type #{argument.class.name} is not implemented"
        end
      end
      return "" if output.empty?
      " " + output.join(' ')
    end
    
    
    # Defines a single tag, such as <br /> or <hr />
    def self.single_attribute_tag(tag)
      puts "Defining single-tag '#{tag}'"  if DEBUG
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
  
  
    standard_tags   = %w{ h1 h2 h3 h4 h5 h6 strong p em title table thead tbody th td tfoot div span abbr acronym address dd dl dt li ol ul tt pre sup }
    special_tags    = [['tr', '_tr'], ['sub', '_sub']]
    tags = standard_tags + special_tags
    puts "Tag definitions: #{tags.inspect}" if DEBUG
    tags.each do |tag|
      if tag.class.name == 'String'
        self.attribute_tag(tag)
      else
        self.attribute_tag(tag[0], tag[1])
      end
    end
    
    %w{br hr}.each do |tag|
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
        puts "Array:#{tag_name} (with args #{args.inspect})" if DEBUG
        result = []
        self.each do |object|
          puts "Object: #{object.inspect} (Type: #{object.class.name})" if DEBUG
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
    
    # Test examples:  
    #   [:aaa, 'hellloooo'].td
    #   [:aaaa, [:bbb, :ccc, :ddd], :fff, :ggg].td
    #   ["Joe", "Marcus", "Chris", "Jim", "Aaron"] 
    #   %w{One Two Three Four}.td(class: :numbers)
    %w{td li}.each do |tag|
      self.array_attribute_tag(tag)
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