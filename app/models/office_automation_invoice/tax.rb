module OfficeAutomationInvoice
  class Tax
    include Mongoid::Document

    ## Fields
    field :name
    field :value, type: Float

    ## Validations
    validates :name, presence: true, uniqueness: true
    validates :value, numericality: { greater_than: 0.1, less_than: 100.0 }

    ## Relationships
    has_and_belongs_to_many :invoice
  end
end
