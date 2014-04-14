require 'spec_helper'

module OfficeAutomationInvoice
  describe Item do
    context 'checks for fields' do
      it { should have_field(:srn).of_type(Integer) }
      it { should have_field(:description) }
      it { should have_field(:amount).of_type(Float) }
    end

    context 'validation checks' do
      it { should validate_uniqueness_of(:srn) }
      it { should validate_presence_of(:srn) }
      it { should validate_presence_of(:description) }
      it { should validate_length_of(:description).less_than(200) }
      it { should validate_presence_of(:amount) }
    end

    context 'association checks' do
      it { should be_embedded_in(:invoice) }
    end
  end
end
