require_dependency "office_automation_invoice/application_controller"

module OfficeAutomationInvoice
  class InvoicesController < ApplicationController

    def new
      @invoice = Invoice.new
      @invoice.items.build
    end

    def create
      event_status, event_error = 200, nil

      unless params[:commit].nil? # creating new invoice
        @invoice = Invoice.new(invoice_params)
        if @invoice.valid?

          # add event to calendar if schedule_period is given
          if @invoice.schedule_period.present? and @invoice.schedule_period.nonzero?
            client = @invoice.build_client
            service = client.discovered_api('calendar', CALENDAR_VERSION)
            result = client.execute(api_method: service.events.insert,
                                    parameters: { 'calendarId' => 'primary' },
                                    body: JSON.dump(@invoice.event_body),
                                    headers: {'Content-Type' => 'application/json'})

            if result.response.env.status != 200
              event_status = result.response.env.status
              event_error = result.data.error["message"]
            end
          end

          if event_status == 200 and @invoice.save
            flash[:notice] = 'Invoice created successfully.'
            @invoice = Invoice.new
            @invoice.items.build
          elsif event_status != 200
            flash[:danger] = "Error while creating invoice : #{event_error}"
          end
        
        else
          flash[:notice] = 'Please fill the fields accordingly.'
        end

      else  # calculating total( not saving invoice )
        @invoice = Invoice.new(invoice_params)
        if @invoice.valid?
          @invoice.calculate_total
        else
          flash[:notice] = 'Please fill the fields accordingly.'
        end
      end

      respond_to do |format|
        format.js
      end
    end

    protected

    def invoice_params
      params.require(:invoice).permit(:issue_date, :due_date, :schedule_period, :schedule_type, :discount, :total_amount, tax_ids: [], items_attributes: [:id, :srn, :description, :amount, :_destroy] )
    end
  end
end
