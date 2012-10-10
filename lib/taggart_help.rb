module TaggartHelp

  def self.help
    puts "Welcome to Taggart (#{Taggart::VERSION} Build #{Taggart::BUILD})"
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
    true
  end


  def self.info
    self.help
  end


  def self.tags
    "Taggart's tags:\n" +
    "~~~~~~~~~~~~~~~"
    "This is a list of the tags that Taggart can generate, for your pleasure\n" +
    "\nStandard tags:\n" +
    "--------------\n" +
    "These tags have a start- and end-tag and the take any number of\n" +
    "attributes in the form of a hash with key-value pairs.\n" +
    output_tags(Taggart::String::STANDARD_TAGS) +
    "\nSpecial tags\n" +
    "------------\n" +
    "These tags behave like the Standard tags, but there's already a\n" +
    "method defined for the String instance so these tags have to be\n" +
    "treated in a slightly special way, in that the tag that's ouputted\n" +
    "doesn't have the same method name. I.e to output <tr> you call '._tr'\n" +
    "however, you don't really need to bother with knowing this as Taggart\n" +
    "does some magic behind the scenes to determine wheter you are asking\n" +
    "for a Taggart tag or the original method.\n" +
    (Taggart::String::SPECIAL_TAGS.sort.map do |tag_pair|
      "  Tag: #{('<' + tag_pair[0] + '>').ljust(6)}  Method: .#{tag_pair[1]}"
    end).join("\n") +
    "\n\nSingle Tags\n" +
    "-------------\n" +
    "Single tags are tags that do not an end tag, <br> is one such tag\n" +
    "In Taggart Single Tags behave just like Standard tags; you can\n" +
    "add attributes to them.\n" +
    output_tags(Taggart::String::SINGLE_TAGS) +
    "\nSmart Tags\n" +
    "------------\n" +
    "These tags go to the gifted class and can speak elvish. They know what\n" +
    "you want from them. They don't behave like the other ones in the sense\n" +
    "that you have a string that you want to turn into something, not just a\n" +
    "simple tag.\n" +
    "Here's the pupils of the gifted class:\n" +
    ".img    - Turns a URL to an image into an img tag.\n" +
    ".href   - turns a URL into the href-portion of an A-tag, takes the link\n" +
    "          content as a parameter, and also other attributes as 2nd argument.\n" +
    ".script - Either turns a URL to a script file into a <script src..></script>\n" +
    "          tag, or embeds a script source in <script></script> tags. Smart!\n" +
    "\nArray tags\n" +
    "----------\n" +
    "The Array Tags generate HTML tags out of a list of strings in an array.\n" +
    "For example, you can turn an array into list items by callin the .li-\n" +
    "method on the array.\n" +
    "You can also pass attributes to the tags as with the Standard Tags\n" +
    "The tags are:\n" +
    "   td        li\n" +
    "\nSmart Array Tags\n" +
    "-----------------\n" +
    "The Smart Array Tags are all a bit more smartly dressed than the\n" +
    "proletarian Array Tags. Namely, they figure out what you do.\n" +
    "Here's the honour roll\n" +
    "Method   Tag   Special powers\n" +
    ".ol    - Turns an array into an ordered list, wrapping the array elements\n" +
    "         in <li> tags so you get your awesome list in one go\n" +
    ".ul    - The almost identical twin of .ol\n" +
    ".tr    - Like .ol and .li, but wraps the array in <tr> tags with every\n" +
    "         element wrapped in a <td> tag.\n" +
    ".table - The smartest of them all. Creates a complete table from a, one or\n" +
    "         two dimensional Array. Each array is wrapped in the <tr> tag with\n" +
    "         every element in the Array in <td> tags. It's all finished off\n" +
    "         with a decoration of <table>.\n" +
    "\nTag arrays and methods\n" +
    "----------------------\n" +
    "You can access the following arrays and methods containing the tags.\n" +
    "Tags           Array                            Method\n" +
    "Standard tags  Taggart::String::STANDARD_TAGS   Taggart.standard_tags\n" +
    "Special tags   Taggart::String::SPECIAL_TAGS    Taggart.special_tags\n" +
    "Single tags    Taggart::String::SINGLE_TAGS     Taggart.single_tags"
  end

  private

  def self.output_tags(tags)
    columns = 4
    padding = 14
    
    output = "  "
    tags.sort.each_with_index do |tag, index| 
      index += 1
      output += "#{tag.ljust(padding)}" 
      output += "\n  " if ((index % columns) == 0) and (index > 0)
    end
    output + "\n\n"
  end

end
