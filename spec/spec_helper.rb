# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'simplecov'
SimpleCov.start

require File.expand_path("../dummy/config/environment", __FILE__)
require File.expand_path("../../lib/office_automation_invoice", __FILE__)

require 'mongoid-rspec'
require 'rspec/rails'
require 'rspec/autorun'

Dir[OfficeAutomationInvoice::Engine.root.join("spec/factories/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end

  config.before(:each) do
    DatabaseCleaner.clean
  end

  config.order = "random"

  config.include Mongoid::Matchers, type: :model

  config.include FactoryGirl::Syntax::Methods
end
