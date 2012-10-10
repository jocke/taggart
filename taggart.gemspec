require 'date'
require './lib/taggart.rb'

Gem::Specification.new do |s|
  s.name          = "taggart"
  s.version       = Taggart::VERSION
  s.date          =  Date.today.strftime('%Y-%m-%d') 
  s.summary       = "Tag Strings with HTML; 'Hello World'.h1"
  s.description   = "Add HTML tags around your strings by running \"Hello World\".h1 for example."
  s.authors       = ["Jocke Selin"]
  s.email         = ["jocke@selincite.com"]
  s.homepage      = "https://github.com/jocke/taggart"
  s.require_paths = ["lib"]
  s.files         = ["lib/taggart.rb", "lib/taggart_help.rb", "Rakefile", "taggart.gemspec", "README.markdown"]
  s.test_files    = ["spec/lib/taggart_spec.rb"]
  s.add_development_dependency ["rake", "rspec", "guard", "guard-rspec", "rb-fsevent"] # rb-fsevent is only required on MacOS.
  s.post_install_message = "Thanks for showing interest in Taggart! Please provide feedback to jocke@selincite.com!"
end
