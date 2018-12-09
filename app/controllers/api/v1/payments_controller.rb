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
    @payment = Payment.new(payment_params)
    @payment.save
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
  def set_payments
    @payment = Payment.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def payment_params
    params.require(:payment).permit(:bill_id, :value)
  end
end
