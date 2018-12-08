# frozen_string_literal: true

class Api::V1::AdmissionsController < ApplicationController
  before_action :set_admission, only: %i[show edit update destroy]

  # GET /admissions
  def index
    @admissions = Admission.all
    json_response(@admissions)
  end

  # GET /admissions/1
  def show
    json_response(@admission)
  end

  # POST /admissions
  def create
    @admission = Admission.new(admission_params)
    @admission.step = @admission.enem_grade > 450 ? 'APPROVED' : 'DISAPPROVED'
    @admission.save
    json_response(@admission)
  end

  # PATCH/PUT /admissions/1
  def update
    @admission.update(admission)
    head :no_content
  end

  # DELETE /admissions/1
  def destroy
    @admission.destroy
    head :no_content
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_admission
    @admission = Admission.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def admission_params
    params.require(:admission).permit(:student_id, :enem_grade)
  end
end
