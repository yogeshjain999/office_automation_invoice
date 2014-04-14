module OfficeAutomationInvoice
  class Item
    include Mongoid::Document

    ## Fields
    field :srn, type: Integer
    field :description
    field :amount, type: Float

    ## Validations
    validates :srn, uniqueness: true, presence: true
    validates :description, presence: true, length: { maximum: 200 }
    validates :amount, presence: true

    ## Relationships
    embedded_in :invoice
  end
end
