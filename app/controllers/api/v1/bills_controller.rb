# frozen_string_literal: true

class Api::V1::BillsController < ApplicationController
  before_action :set_billing, only: %i[show edit update destroy]

  # GET /bills
  def index
    @bill = Bill.all
    json_response(@bill)
  end

  # GET /bills/1
  def show
    json_response(@bill)
  end

  # PATCH/PUT /bill/1
  def update
    @bill.update(bill)
    head :no_content
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_billing
    @bill = bill.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def bill_params
    params.require(:billing).permit(:id, :billing_id)
  end
end
