require 'spec_helper'

module OfficeAutomationInvoice
  describe Tax do
    context 'checks for fields' do
      it { should have_field(:name) }
      it { should have_field(:value).of_type(Float) }
    end

    context 'validation checks' do
      it { should validate_presence_of(:name) }
      it { should validate_uniqueness_of(:name) }
      it { should validate_numericality_of(:value).greater_than(0.1).less_than(100.0) }
    end

    context 'association checks' do
      it { should have_and_belong_to_many(:invoice) }
    end
  end
end
