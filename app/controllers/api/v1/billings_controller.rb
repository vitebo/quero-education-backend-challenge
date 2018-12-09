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
    admission = get_admission_in_the_current_year
    if admission.empty?
      message = 'no admission in that year found'
      return json_response(message: message, status: :no_content, admission: admission)
    end
    admission = admission[0]
    unless admission.enem_grade > 450
      return json_response(message: 'unapproved user', status: :forbidden)
    end
    if Billing.exists?(student_id: admission.student_id)
      message = 'each student has only one billing per year'
      return json_response(message: message, status: :forbidden)
    end
    @billing = Billing.new(billings_params)
    @billing.status = 'PENDING'
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
    params.require(:billing).permit(
      :student_id,
      :total_amount,
      :desired_due_day,
      :installments_count
    )
  end

  def save_bills
    value_by_bill = @billing.total_amount / @billing.installments_count
    due_date = get_first_bill_due_date
    (1..@billing.installments_count).each do |_i|
      bill = Bill.new(
        billing_id: @billing.id,
        value: value_by_bill,
        due_date: due_date,
        status: 'PENDING',
        payment_method: 'CREDIT_CARD', # default value
        month: due_date.month,
        year: due_date.year
      )
      bill.save
      due_date += 1.months
    end
  end

  def get_first_bill_due_date
    current_date = DateTime.now.to_date
    due_date = DateTime.new(current_date.year, current_date.month, @billing.desired_due_day)
    return due_date if current_date.day < due_date.day

    due_date + 1.months
  end

  def get_admission_in_the_current_year
    student_id = billings_params[:student_id]
    dt = DateTime.now.to_date
    Admission.where(
      'created_at >= ? and created_at <= ? and student_id = ?',
      dt.beginning_of_year,
      dt.end_of_year,
      student_id
    )
  end
end
