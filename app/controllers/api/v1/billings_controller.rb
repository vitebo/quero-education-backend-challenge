# frozen_string_literal: true

class Api::V1::BillingsController < ApplicationController
  before_action :set_billing, only: %i[show edit update destroy]

  # GET /billings
  def index
    @billings = Billing.all
    json_response(@billings)
  end

  # GET /billings/1
  def show
    json_response(@billing)
  end

  # POST /billings
  def create
    student_id = billings_params[:student_id]
    is_approved = Admission.exists?(student_id: student_id, step: 'APPROVED')
    unless is_approved
      return json_response(
        message: 'unapproved user',
        status: :forbidden
      )
    end
    @billing = Billing.new(billings_params)
    @billing.save
    save_bills
    json_response(@billing)
  end

  # PATCH/PUT /billings/1
  def update
    @billing.update(billing)
    head :no_content
  end

  # DELETE /billings/1
  def destroy
    @billing.destroy
    head :no_content
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_billing
    @billing = billing.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def billings_params
    params.require(:billing).permit(:student_id, :desired_due_day, :installments_count)
  end

  def save_bills
    value_by_bill = get_value_by_bill
    paid_date = get_paid_date
    (0..@billing.installments_count).each do |_i|
      bill = Bill.new(
        value: value_by_bill,
        due_date: paid_date,
        paid_date: paid_date + 5.days,
        payment_method: 'CREDIT_CARD', # Default value
        month: paid_date.month,
        year: paid_date.year
      )
      bill.save
      paid_date += 1.months
    end
  end

  def get_value_by_bill
    # where to find this information?
    total_billing_amount = 5000
    total_billing_amount / @billing.installments_count
  end

  def get_paid_date
    current_date = DateTime.now.to_date
    if current_date.day < @billing.desired_due_day
      return @billing.desired_due_day
    end

    @billing.desired_due_day + 1.months
  end
end
