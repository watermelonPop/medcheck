class MedicationsController < ApplicationController
  before_action :set_medication, only: %i[ show edit update destroy ]

  # GET /medications or /medications.json
  def index
    @user = current_user
    @medications = @user.medications
  end

  # GET /medications/1 or /medications/1.json
  def show
    @user = current_user
    @schedules = @medication.medication_schedules
    @amount = @medication.amount_left.to_i
    @predicted_date = Date.today + @amount
  end

  # GET /medications/new
  def new
    @user = current_user
    @medication = Medication.new
  end

  # GET /medications/1/edit
  def edit
    @user = current_user
    @medication = @user.medications.find_by(id: params[:id])
  end

  # POST /medications or /medications.json
  def create
    @user = current_user
    @medication = @user.medications.build(medication_params)

    respond_to do |format|
      if @medication.save
        format.html { redirect_to user_medications_path(user_id: @user.id), notice: @medication.name + " was successfully created." }
        format.json { render :show, status: :created, location: @medication }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @medication.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /medications/1 or /medications/1.json
  def update
    @user = current_user
    respond_to do |format|
      if @medication.update(medication_params)
        format.html { redirect_to user_medication_path(user_id: @user.id, id: @medication.id), notice: @medication.name + " was successfully updated." }
        format.json { render :show, status: :ok, location: @medication }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @medication.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /medications/1 or /medications/1.json
  def destroy
    @user = current_user
    @medication = @user.medications.find_by(id: params[:id])
    @medication.medication_schedules.destroy_all

    respond_to do |format|
      if @medication.destroy
        format.html { redirect_to user_medications_path(user_id: @user.id), notice: @medication.name + " was successfully deleted." }
        format.json { head :no_content }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @medication.errors, status: :unprocessable_entity }
      end
    end
  end

  def new_pickup
    @user = current_user
    @medication = @user.medications.find_by(id: params[:medication_id])
    @date = Date.parse(params[:date])
    @amount = params[:amount].to_i
    new_amt = @medication.amount_left.to_i + @amount
    respond_to do |format|
      if @medication.update(amount_left: new_amt, last_picked_up: @date)
        format.html { redirect_to user_medication_path(user_id: @user.id, id: @medication.id), notice: "A new pickup date and amount left has been set for " + @medication.name + "." }
        format.json { head :no_content }
      else
        format.html { render :show, status: :unprocessable_entity }
        format.json { render json: @medication.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_medication
      @medication = Medication.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def medication_params
      params.require(:medication).permit(:name, :dose_amount, :dose_unit, :amount_taken, :amount_left, :last_picked_up, :icon, :color)
    end
end
