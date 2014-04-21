$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "office_automation_invoice/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "office_automation_invoice"
  s.version     = OfficeAutomationInvoice::VERSION
  s.platform    = Gem::Platform::RUBY  
  s.authors     = ["Yogesh Khater"]
  s.email       = ["yogesh@joshsoftware.com"]
  s.homepage    = "https://github.com/joshsoftware/office_automation_invoice"
  s.summary     = "Mountable engine for generating invoices."
  s.description = "Mountable engine for generating invoices based on currency, defined taxes etc. It can also be generated within given schedule."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.0.3"
  s.add_dependency "google-api-client"
end
