class Api::V1::AdmissionsController < ApplicationController
    before_action :set_admission, only: [:show]

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
      @admission = Admission.new(admissions_params)
      if @admission.enem_grade > 450
        @admission.step = 'APPROVED'
      else
        @admission.step = 'DISAPPROVED'
      end
      @admission.save
      json_response(@admission, :created)
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
        @admission = admission.find(params[:id])
      end
  
      # Only allow a trusted parameter "white list" through.
      def admissions_params
        params.require(:admissions).permit(:student_id, :enem_grade)
      end  
end
