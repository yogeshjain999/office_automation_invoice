module OfficeAutomationInvoice
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    # run cron jobs of engine from main app
    #def run_whenever
    #  run "whenever -f #{Engine.root}/config/schedule.rb -i"
    #end
  end
end
