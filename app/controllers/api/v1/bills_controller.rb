# frozen_string_literal: true

class Api::V1::BillsController < ApplicationController
  # GET /billings
  def index
    @bill = Bill.all
    json_response(@bill)
  end
end
