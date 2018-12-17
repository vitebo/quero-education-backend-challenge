class Api::V1::PaymentsController < ApplicationController
  before_action :set_payment, only: %i[show edit update destroy]

  # GET /payments
  def index
    @payments = Payment.all
    json_response(@payments)
  end

  # GET /payments/1
  def show
    json_response(@payment)
  end

  # POST /payments
  def create
    @bill = Bill.find(id=payment_params[:bill_id])
    unless @bill
      return json_response(message: 'bill not found', status: :no_content)
    end
    if payment_params[:value].to_f != @bill.value.to_f
      return json_response(message: 'invalid value', status: :no_content)
    end
    if @bill.status == 'PAID'
      return json_response(message: 'account is already paid', status: :no_content)
    end
    save_payment
    json_response(@payment, :created)
  end

  # PATCH/PUT /payments/1
  def update
    @student.update(payment_params)
    head :no_content
  end

  # DELETE /payments/1
  def destroy
    @payment.destroy
    head :no_content
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_payment
    @payment = Payment.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def payment_params
    params.require(:payment).permit(:bill_id, :value)
  end

  def save_payment
    @payment = Payment.new(payment_params)
    @payment.status = 'PAID'
    @payment.save
    @bill.update(status: 'PAID')
    update_billing
  end

  def update_billing
    @bills = Bill.where('billing_id = ?', @bill.billing_id)
    pending_bills = @bills.select { |bill| bill.status == 'PENDING' }
    if pending_bills.length == 0
      billing = Billing.find(id = @bill.bill_id)
      billing.updated(status: 'PAID')
    end
  end
end
