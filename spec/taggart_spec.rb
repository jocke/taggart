# Run with: rspec -fd -c taggart_spec.rb 
require 'taggart.rb'

describe Taggart::String, "#attribute_tags" do
  
  it "returns a standard tag without any attributes" do
    "hello world".h1.should == '<h1>hello world</h1>'
  end
  
  it "returns a standard tag with one attribute" do
    "hello world".h1(class: :header).should == "<h1 class=\"header\">hello world</h1>"
  end
  
  it "returns a standard tag with two attribute" do
    "hello world".h1(class: :header, id: :title).should == "<h1 class=\"header\" id=\"title\">hello world</h1>"
  end
end


describe Taggart::String, "#single_attribute_tag" do
  
  it "returns a single tag without any attributes" do
    "hello world".br.should == 'hello world<br />'
  end
  
  it "returns a standard tag with one attribute" do
    "hello world".br(class: :header).should == "hello world<br class=\"header\" />"
  end
  
  it "returns a standard tag with two attribute" do
    "hello world".br(class: :header, id: :title).should == "hello world<br class=\"header\" id=\"title\" />"
  end
end

describe Taggart::Array, "#array_attribute_tag" do
  
  it "returns a the array elements as tags without any attributes" do
    %w{one two three}.li.should == "<li>one</li><li>two</li><li>three</li>"
  end
  
  it "returns a the array elements as tags with one attribute" do
    %w{one two three}.td(class: :programmers).should == "<td class=\"programmers\">one</td><td class=\"programmers\">two</td><td class=\"programmers\">three</td>"
  end
  
  it "returns a the array elements as tags with two attribute" do
    %w{one two three}.td(class: :programmers, id: :unpossible).should == "<td class=\"programmers\" id=\"unpossible\">one</td><td class=\"programmers\" id=\"unpossible\">two</td><td class=\"programmers\" id=\"unpossible\">three</td>"
  end
  
  it "returns a the array symbol elements as tags without attributes" do
    [:one, :two, :three].td.should == "<td>one</td><td>two</td><td>three</td>"
  end
  
  it "returns a the nested array elements as tags without attributes" do
    [:one, [:nine, :eight, :seven], :two, :three].td.should == "<td>one</td><td><td>nine</td><td>eight</td><td>seven</td></td><td>two</td><td>three</td>"
  end
  
  
  describe Taggart::String, "#dual_tr" do
    it "executes translate-tr when two parameters of string is passed in" do
      "Jolly Roger".tr('J','G').tr('R', 'B').should == "Golly Boger"
    end
    
    it "executes tag-tr when no parameters are passed in" do
      "Jolly Roger".tr.should == "<tr>Jolly Roger</tr>"
    end
    
    it "executes tag-tr when hash parameters are passed in" do
      "Jolly Roger".tr(id: :jolly_roger).should == "<tr id=\"jolly_roger\">Jolly Roger</tr>"
    end
    
    it "executes translate-tr when the first example from the Ruby documentation is executed" do
      "hello".tr('el', 'ip').should == "hippo"
    end
    
    it "executes translate-tr when the second example from the Ruby documentation is executed" do
      "hello".tr('aeiou', '*').should == "h*ll*"
    end
    
    it "executes translate-tr when the third example from the Ruby documentation is executed" do
      "hello".tr('a-y', 'b-z').should == "ifmmp"
    end
    
    it "executes translate-tr when the fourth example from the Ruby documentation is executed" do
      "hello".tr('^aeiou', '*').should == "*e**o"
    end
  end
  
  
  describe Taggart::String, "#dual_sub" do
    it "executes substitute-sub when the first example from the documentation is passed in" do
      "hello".sub(/[aeiou]/, '*').should == "h*llo"
    end
    
    it "executes substitute-sub when the 2nd example from the documentation is passed in" do
      "hello".sub(/([aeiou])/, '<\1>').should == "h<e>llo"
    end
    
    it "executes substitute-sub when a simple block is provided" do
      "hello".sub(/./) {|s| "-#{s}-" }.should == "-h-ello"
    end
    
    it "executes substitute-sub when the third example, with a block, from the documentation is passed in" do
      "hello".sub(/./) {|s| s.ord.to_s + ' ' }.should == "104 ello"
    end
    
    it "executes substitute-sub when the fourth example, with a regexp, from the documentation is passed in" do
      'Is SHELL your preferred shell?'.sub(/[[:upper:]]{2,}/, ENV).should == "Is /bin/bash your preferred shell?"
    end
    
    it "executes substitute-sub when the fifth example, with a regexp, from the documentation is passed in" do
      "hello".sub(/(?<foo>[aeiou])/, '*\k<foo>*').should == "h*e*llo"
    end
    
    it "executes tag-sub when no parameters are passed in" do
      "You're just a substitute".sub.should == "<sub>You're just a substitute</sub>"
    end

    it "executes tag-sub when a hash of attribute-values are passed in" do
      "You're just a substitute".sub(id: :thingy).should == "<sub id=\"thingy\">You're just a substitute</sub>"
    end
    
    it "executes tag-sub when a hash of two attribute-values are passed in" do
      "You're just a substitute".sub(id: :thingy, class: :lowlowlow).should == "<sub id=\"thingy\" class=\"lowlowlow\">You're just a substitute</sub>"
    end
  end
  
  
  describe Taggart::String, "More complex use" do
    it "builds a small table HTML" do
      row_1 = %w(r1c1 r1c2 r1c3)
      row_2 = %w(r2c1 r2c2 r2c3)
      (row_1.td.tr + row_2.td.tr).table.should == "<table><tr><td>r1c1</td><td>r1c2</td><td>r1c3</td></tr><tr><td>r2c1</td><td>r2c2</td><td>r2c3</td></tr></table>" 
    end
    
    it "builds an ordered list HTML" do
      %w(First Second Third Fourth Fifth Sizt Seventh).li.ol.should == "<ol><li>First</li><li>Second</li><li>Third</li><li>Fourth</li><li>Fifth</li><li>Sizt</li><li>Seventh</li></ol>" 
    end
  end
  
  
  describe Taggart::String, "Special tags" do
    context "href tags" do
      it "renders a basic <a href>-tag." do 
        "/hello/world.html".href("Hello World").should == "<a href=\"/hello/world.html\">Hello World</a>"
      end
      
      it "renders a basic <a href>-tag without an explicit label." do 
        "/hello/world.html".href.should == "<a href=\"/hello/world.html\">/hello/world.html</a>"
      end
      
      it "renders a <a href>-tag with an attribute." do 
        "/hello/world.html".href("Hello World", {class: :linky}).should == "<a class=\"linky\" href=\"/hello/world.html\">Hello World</a>"
      end
      
      it "renders a <a href>-tag with an attribute, but without an explicit label." do 
        "/hello/world.html".href(nil, {class: :linky}).should == "<a class=\"linky\" href=\"/hello/world.html\">/hello/world.html</a>"
      end
      
      it "renders a <a href>-tag with two attributes." do 
        "/hello/world.html".href("Hello World", {class: :linky, title: 'Clicky the linky!'}).should == "<a class=\"linky\" title=\"Clicky the linky!\" href=\"/hello/world.html\">Hello World</a>"
      end
    end
    
    context "img tags" do 
      it "renders a basic <img>-tag." do
        "/path/to/img.png".img.should == "<img src=\"/path/to/img.png\" />"
      end
      
      it "renders a <img>-tag with an attribute." do
        "/path/to/img.png".img({class: :thumbnail}).should == "<img class=\"thumbnail\" src=\"/path/to/img.png\" />"
      end
      
      it "renders a <img>-tag with two attributes." do
        "/path/to/img.png".img({class: :slideshow, alt: :'Rainbows and fluffy animals'}).should == "<img class=\"slideshow\" alt=\"Rainbows and fluffy animals\" src=\"/path/to/img.png\" />"
      end
    end
    
    context "script tags" do
      it "should render a script tag with src-attribute when the string ends in .js" do
        "/jabbarscript/waste_cpu_cycles.js".script.should == "<script type=\"text/javascript\" src=\"/jabbarscript/waste_cpu_cycles.js\"></script>"
      end
      
      it "should render a script tag with src-attribute and an id-attribute  when the string ends in .js" do
        "/jabbarscript/fancy_pants.js".script(id: 'fancy_fancy').should == "<script id=\"fancy_fancy\" type=\"text/javascript\" src=\"/jabbarscript/fancy_pants.js\"></script>"
      end
      
      it "should render a script tag with when the string does not ends in .js" do
        "document.write(\"Hello World!\");".script(id: 'pants_pants').should == "<script id=\"pants_pants\" type=\"text/javascript\">document.write(\"Hello World!\");</script>"
      end
    end
    
    context "combinations" do
      it "renders a clickable image" do
        "/path/to/img.png".img({class: :thumbnail}).a(href: '/hello/world.html').should == "<a href=\"/hello/world.html\"><img class=\"thumbnail\" src=\"/path/to/img.png\" /></a>"
      end
    end
  end
end