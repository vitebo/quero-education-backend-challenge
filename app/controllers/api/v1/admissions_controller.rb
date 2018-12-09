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
    current_year = DateTime.now.to_date.year
    student_id = admission_params[:student_id]
    has_admission = Admission.exists?(student_id: student_id)
    if has_admission
      old_admission = Admission.find(student_id = student_id)
      if old_admission.created_at.year == current_year
        return json_response(
          message: 'each student has only one admission per year',
          status: :forbidden
        )
      end
    end
    @admission = Admission.new(admission_params)
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
