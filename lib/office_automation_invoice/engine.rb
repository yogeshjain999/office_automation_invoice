module OfficeAutomationInvoice
  class Engine < ::Rails::Engine
    isolate_namespace OfficeAutomationInvoice

    config.generators do |i|
      i.template_engine :haml
      i.test_framework :rspec, fixture: false
      i.fixture_replcement :factory_girl, dir: 'spec/factories'
    end
  end
end
