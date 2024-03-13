class MedicationsController < ApplicationController
  def time_for_day(day)
    medication_schedules.find_by(day_of_week: day)&.time
  end

  # GET /medications or /medications.json
  def index
    @user = current_user
    @medications = Medication.all
  end

  # GET /medications/1 or /medications/1.json
  def show
    @user = current_user
    @medication = @user.medications.find_by(name: params[:name])
    if @medication.nil?
      redirect_to user_path(@user), alert: "Medication not found"
    end
  end

  # GET /medications/new
  def new
    @user = current_user
    @medication = Medication.new
  end

  # GET /medications/1/edit
  def edit
    @user = current_user
    @medication = @user.medications.find_by(name: params[:name])
    if @medication.nil?
      redirect_to user_path(@user), alert: "Medication not found"
    end
  end

  # POST /medications or /medications.json
  def create
    @user = current_user
    @medication = @user.medications.build(medication_params)

    respond_to do |format|
      if @medication.save
        format.html { redirect_to user_medications_path(@user), notice: "Medication was successfully created." }
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
    @medication = @user.medications.find_by(name: params[:name])
    if @medication.nil?
      redirect_to user_path(@user), alert: "Medication not found"
      return
    end
    respond_to do |format|
      if @medication.update(medication_params)
        format.html { redirect_to user_medication_path(user_id: session[:user_id], name: @medication.name), notice: "Medication was successfully updated." }
        format.json { render :show, status: :ok, location: @medication }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @medication.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @medication = @user.medications.find_by(name: params[:name]) # Change "params[:name]" to "params[:id]"
    if @medication.destroy
      redirect_to user_medications_path(@user), notice: "Medication successfully deleted."
    else
      redirect_to user_medications_path(@user), alert: "Failed to delete medication."
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_medication
      @medication = Medication.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def medication_params
      params.require(:medication).permit(:name, :amount_taken, :dose_unit, :dose_amount, :amount_left, :last_picked_up, :icon, :color)
    end
end
