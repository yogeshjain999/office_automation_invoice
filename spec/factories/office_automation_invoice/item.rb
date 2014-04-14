module OfficeAutomationInvoice
  FactoryGirl.define do
    factory :item, class: Item do

      # for unique srn
      sequence :srn do |n|
        n
      end
      description "Fees towards software development"
      amount 100
      invoice
    end
  end
end
