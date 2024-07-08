require 'rails_helper'

RSpec.describe MedicationSchedulesController do
        before do
                User.destroy_all
                User.create({ first_name: 'Test', last_name: 'Test', email: 'test@gmail.com' })
                User.find_by(email: 'test@gmail.com').medications.create(name: 'TestMed', dose_amount: 100, dose_unit: 'mg', amount_taken: 1, amount_left: '70', last_picked_up: Date.today, icon: '<i class=\"fa-solid fa-tablets\"></i>', color: 'rgb(108, 160, 220)')
                User.find_by(email: 'test@gmail.com').medications.find_by(name: 'TestMed').medication_schedules.create(time: "11:30", day_of_week: 'Everyday', taken: false)
        end
        let!(:user) { User.find_by(email: 'test@gmail.com') }

        describe "GET /index" do
                before { session[:user_id] = user.id }
                it 'renders index page' do
                        get :index, params: { user_id: user.id, medication_id: user.medications.find_by(name: 'TestMed').id }
                        expect(response).to render_template(:index)
                end
                it 'returns ok status' do
                        get :index, params: { user_id: user.id, medication_id: user.medications.find_by(name: 'TestMed').id }
                        expect(response).to have_http_status(:ok)
                end
                it 'sets the medication schedules variable' do
                        get :index, params: { user_id: user.id, medication_id: user.medications.find_by(name: 'TestMed').id }
                        expect(assigns(:medication_schedules)).to eq(user.medications.find_by(name: 'TestMed').medication_schedules)
                end
        end

        describe "GET /new" do
                before { session[:user_id] = user.id }
                it 'renders new page' do
                        get :new, params: { user_id: user.id, medication_id: user.medications.find_by(name: 'TestMed').id }
                        expect(response).to render_template(:new)
                end
                it 'returns ok status' do
                        get :new, params: { user_id: user.id, medication_id: user.medications.find_by(name: 'TestMed').id }
                        expect(response).to have_http_status(:ok)
                end
        end

        describe "POST /create" do
                before { 
                        session[:user_id] = user.id 
                        user.medications.find_by(name: 'TestMed').medication_schedules.destroy_all
                }

                context 'with valid parameters' do
                        it 'has a :found status' do
                                post :create, params: { 
                                        user_id: user.id, 
                                        medication_id: user.medications.find_by(name: 'TestMed').id,
                                        medication_schedule: { 
                                              time: "11:30",
                                              day_of_week: 'Everyday', 
                                              taken: false
                                        }
                                }  
                                expect(response).to have_http_status(:found)
                        end
                        it 'successfully creates a medication schedule' do
                                user.medications.find_by(name: 'TestMed').medication_schedules.destroy_all

                                post :create, params: { 
                                          user_id: user.id, 
                                          medication_id: user.medications.find_by(name: 'TestMed').id,
                                          medication_schedule: { 
                                                time: "11:30",
                                                day_of_week: 'Everyday', 
                                                taken: false
                                          }
                                }

                                expect(user.medications.find_by(name: 'TestMed').medication_schedules.count).to eq(1)
                        end
                        it 'successfully redirects to the show medication page' do
                                post :create, params: {
                                        user_id: user.id,
                                        medication_id: user.medications.find_by(name: 'TestMed').id,
                                        medication_schedule: { 
                                                time:"11:30", day_of_week: 'Everyday', taken: false
                                        }
                                }
                                expect(response).to redirect_to(new_user_medication_medication_schedule_path(user_id: user.id, medication_id: user.medications.find_by(name: 'TestMed').id))
                        end
                end

                context 'invalid time input' do
                        it 'has a :unprocessable_entity status' do
                                post :create, params: { 
                                        user_id: user.id, 
                                        medication_id: user.medications.find_by(name: 'TestMed').id,
                                        medication_schedule: { 
                                              time: "Hello",
                                              day_of_week: 'Everyday', 
                                              taken: false
                                        }
                                }  
                                expect(response).to have_http_status(:unprocessable_entity)
                        end
                        it 'renders the new template' do
                                post :create, params: { 
                                        user_id: user.id, 
                                        medication_id: user.medications.find_by(name: 'TestMed').id,
                                        medication_schedule: { 
                                              time: "Hello",
                                              day_of_week: 'Everyday', 
                                              taken: false
                                        }
                                }  
                                expect(response).to render_template(:new)
                        end
                end
                
        end

        describe 'DELETE /destroy' do
                before { session[:user_id] = user.id }
                it 'has a successful status' do
                        delete :destroy, params: {
                                user_id: user.id, 
                                medication_id: user.medications.find_by(name: 'TestMed').id,
                                id: user.medications.find_by(name: 'TestMed').medication_schedules.first.id
                        }
                        expect(response).to have_http_status(:found)
                end
                it 'deletes medication successfully' do
                        delete :destroy, params: {
                                user_id: user.id, 
                                medication_id: user.medications.find_by(name: 'TestMed').id,
                                id: user.medications.find_by(name: 'TestMed').medication_schedules.first.id
                        }
                        expect(user.medications.find_by(name: 'TestMed').medication_schedules.count).to eq(0)
                end
                it 'redirects to user medications page' do
                        delete :destroy, params: {
                                user_id: user.id, 
                                medication_id: user.medications.find_by(name: 'TestMed').id,
                                id: user.medications.find_by(name: 'TestMed').medication_schedules.first.id
                        }
                        expect(response).to redirect_to(user_medication_medication_schedules_path(user_id: user.id, medication_id: user.medications.find_by(name: 'TestMed').id))
                end
        end

        describe 'GET get_day_schedules' do
                before { session[:user_id] = user.id }
                it 'has a successful status' do
                        get :get_day_schedules, params: {
                                user_id: user.id, 
                                medication_id: user.medications.find_by(name: 'TestMed').id,
                                day_of_week: "Everyday"
                        }
                        expect(response).to have_http_status(:ok)
                end

                it 'sets current_day_schedules' do
                        get :get_day_schedules, params: {
                                user_id: user.id, 
                                medication_id: user.medications.find_by(name: 'TestMed').id,
                                day_of_week: "Everyday"
                        }
                        expect(assigns(:current_day_schedules)).to be_present
                end
        end

        describe 'GET get_today_schedules' do
                before { session[:user_id] = user.id }
                it 'has a successful status' do
                        get :get_today_schedules, params: {
                                user_id: user.id
                        }
                        expect(response).to have_http_status(:ok)
                end

                it 'sets current_day_schedules' do
                        get :get_today_schedules, params: {
                                user_id: user.id
                        }
                        expect(assigns(:current_day_schedules)).to be_present
                end
        end
end