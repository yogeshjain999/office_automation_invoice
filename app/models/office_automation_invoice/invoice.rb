module OfficeAutomationInvoice
  class Invoice
    include Mongoid::Document
    include Mongoid::Timestamps

    ## Fields
    field :number, type: Integer, default: ->{ self.class.count + 1 }
    field :issue_date, type: Date
    field :due_date, type: Date
    field :schedule_type
    field :schedule_period, type: Integer
    field :status, default: "Incomplete"
    field :discount, type: Float, default: 0
    field :sub_total, type: Float, default: 0
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
    before_save :calculate_total

    def calculate_total
      if items.empty?
        errors[:items] = "can't be blank"
      else
        # calculate subtotal
        self.sub_total = items.sum(:amount)

        # adding discount
        self.total_amount = sub_total - ((sub_total * discount) / 100)

        # adding tax
        self.total_amount += (total_amount * (taxes.sum(:value)) / 100)
      end
    end

    def build_client
      key = Google::APIClient::KeyUtils.load_from_pkcs12(KEY_FILE, KEY_SECRET)
      client = Google::APIClient.new(application_name: OfficeAutomationInvoice.to_s, application_version: VERSION)
      client.authorization = Signet::OAuth2::Client.new(
        :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
        :audience => 'https://accounts.google.com/o/oauth2/token',
        :scope => 'https://www.googleapis.com/auth/calendar',
        :issuer => SERVICE_ACC_EMAIL,
        :grant_type => 'urn:ietf:params:oauth:grant-type:jwt-bearer',
        :access_type => 'offline',
        :signing_key => key 
      )
      client.authorization.fetch_access_token!
      client
    end

    def event_body
      {
        summary: "Invoice",
        start: { date: issue_date.to_s },
        end: { date: issue_date.to_s },
        recurrence: ["RRULE:FREQ=#{ schedule_type.upcase };UNTIL=#{ due_date.strftime('%Y%m%dT%H%M%SZ') };INTERVAL=#{ schedule_period };"]
      }
  end

end
end
