module OfficeAutomationInvoice
  FactoryGirl.define do
    factory :tax, class: Tax do
      sequence(:name) do |n|
        "tax#{n}"
      end
      value 4.25
    end
  end
end
