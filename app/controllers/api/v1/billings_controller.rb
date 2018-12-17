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
    json_response(billing: @billing, bills: @bills)
  end

  # POST /billings
  def create
    student_id = billings_params[:student_id]
    admissions = Admission.where(student_id: student_id)
    if admissions.empty?
      return json_response(message: 'no admission found', status: :no_content)
    end

    approved_admissions = admissions.select { |admission| admission.enem_grade > 450 }
    if approved_admissions.empty?
      return json_response(message: 'unapproved user', status: :forbidden)
    end

    installments_count = billings_params[:installments_count].to_i
    if installments_count > 12 or installments_count < 1
      return json_response(message: 'invalid value', status: :no_content)
    end

    @billing = Billing.new(billings_params)
    @billing.status = 'PENDING'
    @billing.save
    save_bills
    json_response(@billing)
  end

  # PATCH/PUT /billings/1
  def update
    payment_method = billings_params['payment_method']
    unless %w[CREDIT_CARD PAYMENT_SLIP].include? payment_method
      return json_response(message: 'invalid parameters')
    end

    dt = DateTime.now.to_date
    next_bills = @bills.select { |bill| bill.created_at > dt }
    next_bills.each do |bill|
      bill.update(payment_method: payment_method)
    end
    @billing.update(payment_method: payment_method)
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
    @billing = Billing.find(params[:id])
    @bills = Bill.where(billing_id: @billing.id)
  end

  # Only allow a trusted parameter "white list" through.
  def billings_params
    params.require(:billing).permit(
      :student_id,
      :total_amount,
      :desired_due_day,
      :installments_count,
      'payment_method'
    )
  end

  def save_bills
    value_by_bill = @billing.total_amount / @billing.installments_count
    due_date = get_first_bill_due_date
    payment_method = billings_params['payment_method']
    (1..@billing.installments_count).each do |_i|
      bill = Bill.new(
        billing_id: @billing.id,
        value: value_by_bill,
        due_date: due_date,
        status: 'PENDING',
        payment_method: payment_method,
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
end
