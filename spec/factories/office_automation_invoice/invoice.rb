module OfficeAutomationInvoice
  FactoryGirl.define do
    factory :invoice, class: Invoice do
      issue_date { Date.current }
      due_date { Date.current }
      discount 5
      schedule_period [1, 'm']
      
      ignore do
        item_count 5
      end

      before(:create) do |invoice, evaluator|
        create_list(:item, evaluator.item_count, invoice: invoice)
      end

      factory :invoice_with_tax do
        ignore do
          tax_count 2
        end

        before(:create) do |invoice, evaluator|
          create_list(:tax, evaluator.tax_count, invoice: [invoice])
        end
      end
    end
  end
end
