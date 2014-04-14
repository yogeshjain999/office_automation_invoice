module OfficeAutomationInvoice
  class Invoice
    include Mongoid::Document
    include Mongoid::Timestamps

    ## Fields
    field :number, type: Integer, default: ->{ self.class.count + 1 }
    field :issue_date, type: Date
    field :due_date, type: Date
    field :schedule_date, type: Date
    field :schedule_period, type: Array, default: []
    field :status, default: "Incomplete"
    field :discount, type: Float, default: 0
    field :total_amount, type: Float, default: 0
    field :due_amount, type: Float
    field :note

    ## Relationships
    has_and_belongs_to_many :taxes, class_name: 'OfficeAutomationInvoice::Tax'
    embeds_many :items, class_name: 'OfficeAutomationInvoice::Item'
    belongs_to :project

    ## Nested attributes
    accepts_nested_attributes_for :items, allow_destroy: true
    accepts_nested_attributes_for :taxes

    ## Validations
    validates :number, numericality: { only_integer: true }, uniqueness: true   
    validates :issue_date, :due_date, presence: true
    validates :note, length: { maximum: 200, allow_blank: true }

    ## Callbacks
    before_save :calculate_total, :set_schedule

    protected

    def calculate_total
      if items.empty?
        errors[:items] = "can't be blank"
      else
        # adding discount
        self.total_amount = items.sum(:amount) - ((items.sum(:amount) * discount) / 100)

        # adding tax
        self.total_amount += (total_amount * (taxes.sum(:value)) / 100)
      end
    end

    def set_schedule
      if schedule_period.empty?
        self.schedule_date = nil    # cancel schedule of invoice
      else
        self.schedule_date = case(schedule_period[1])   # set schedule of invoice
                             when 'y'
                               (schedule_date or Date.current).next_year(schedule_period[0])
                             when 'q'
                               (schedule_date or Date.current).next_quarter(schedule_period[0])
                             when 'm'
                               (schedule_date or Date.current).next_month(schedule_period[0])
                             when 'w'
                               (schedule_date or Date.current).next_week(schedule_period[0])
                             else
                               (schedule_date or Date.current).next_day(schedule_period[0])
                             end
      end
    end
  end
end
