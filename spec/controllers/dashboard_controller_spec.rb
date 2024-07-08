require 'rails_helper'

RSpec.describe DashboardController do
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
                        get :index, params: { user_id: user.id }
                        expect(response).to render_template(:index)
                end
                it 'returns ok status' do
                        get :index, params: { user_id: user.id }
                        expect(response).to have_http_status(:ok)
                end
        end

        describe 'GET set_taken' do
                before { session[:user_id] = user.id }
                it 'returns found status' do
                        get :set_taken, params: { 
                                user_id: user.id,
                                medication_id: user.medications.find_by(name: 'TestMed').id,
                                id: user.medications.find_by(name: 'TestMed').medication_schedules.first.id
                        }
                        expect(response).to have_http_status(:found)
                end
                it 'sets taken for the medication schedule' do
                        get :set_taken, params: { 
                                user_id: user.id,
                                medication_id: user.medications.find_by(name: 'TestMed').id,
                                id: user.medications.find_by(name: 'TestMed').medication_schedules.first.id
                        }
                        expect(user.medications.find_by(name: 'TestMed').medication_schedules.first.taken).to eq(true)
                end

                it 'redirects to the dashboard index' do
                        get :set_taken, params: { 
                                user_id: user.id,
                                medication_id: user.medications.find_by(name: 'TestMed').id,
                                id: user.medications.find_by(name: 'TestMed').medication_schedules.first.id
                        }
                        expect(response).to redirect_to(user_dashboard_index_path(user_id: user.id))
                end
                context 'day taken exists' do
                        it 'finds the specified day taken' do
                                user.day_takens.create(date: Date.today, medication_schedule_id:user.medications.find_by(name: 'TestMed').medication_schedules.first.id)
                                get :set_taken, params: { 
                                        user_id: user.id,
                                        medication_id: user.medications.find_by(name: 'TestMed').id,
                                        id: user.medications.find_by(name: 'TestMed').medication_schedules.first.id
                                }
                                expect(user.day_takens.first.taken).to eq(true)
                        end
                end
                context 'day taken doesnt exist' do
                        it 'creates new day taken' do
                                expect{
                                get :set_taken, params: { 
                                        user_id: user.id,
                                        medication_id: user.medications.find_by(name: 'TestMed').id,
                                        id: user.medications.find_by(name: 'TestMed').medication_schedules.first.id
                                }}.to change(user.day_takens, :count).by(1)
                        end
                end
        end
end