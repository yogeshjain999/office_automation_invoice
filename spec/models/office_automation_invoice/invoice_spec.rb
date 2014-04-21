require 'spec_helper'

module OfficeAutomationInvoice
  describe Invoice do

    context 'checks for invoice fields' do
      it { should have_field(:number).of_type(Integer) }
      it { should have_fields(:issue_date, :due_date).of_type(Date) }
      it { should have_fields(:total_amount, :due_amount, :discount).of_type(Float) }
      it { should have_field(:status).with_default_value_of("Incomplete") }
      it { should have_field(:schedule_date) }
      it { should have_field(:schedule_period) }
      it { should have_field(:note) }
    end

    context 'validation checks' do
      it { should validate_uniqueness_of(:number) }
      it { should validate_numericality_of(:number) }
      it { should validate_presence_of(:issue_date) }
      it { should validate_presence_of(:due_date) }
      it { should validate_length_of(:note).less_than(200) }
    end

    context 'association checks' do
      it { should have_and_belong_to_many(:taxes) }
      it { should embed_many(:items) }
      it { should belong_to(:project) }
    end

    context 'nested attributes checks' do
      it { should accept_nested_attributes_for(:items) }
      it { should accept_nested_attributes_for(:taxes) }
    end

    context '#calculate_total' do
      it 'calculates total amount of 5 items with discount 2% and subtotal of 500' do
        invoice = create(:invoice)

        expect(invoice.items.count).to eql(5)
        expect(invoice.total_amount).to eql(475.0)
      end

      it 'calculates total amount of 5 items with 2% discount, 2 taxes(each of 4.25%) and subtotal of 500' do
        invoice = create(:invoice_with_tax)

        expect(invoice.taxes.count).to eql(2)
        expect(invoice.total_amount).to eql(515.375)
      end

      it 'fails if invoice is created without items' do
        invoice = create(:invoice, item_count: 0)

        expect(invoice.errors[:items]).to eql(["can't be blank"])
      end
    end

    context '#set_schedule' do
      xit 'sets schedule to 1 week after project start date' do 
      end

      xit 'sets schedule_date to next schedule' do        
      end

      it 'cancels schedule if schedule_period is empty' do
        invoice = create(:invoice, schedule_date: Date.current)
        invoice.schedule_period = []
        invoice.set_schedule

        expect(invoice.reload.schedule_date).to be_nil
      end

      xit 'sets schedule_period to 1 month instead of 1 week after scheduled date' do
      end
    end
  end
end
