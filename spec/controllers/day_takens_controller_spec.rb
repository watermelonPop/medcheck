require 'rails_helper'

RSpec.describe DayTakensController do
        before do
                User.destroy_all
                User.create({ first_name: 'Test', last_name: 'Test', email: 'test@gmail.com' })
                User.find_by(email: 'test@gmail.com').medications.create(name: 'TestMed', dose_amount: 100, dose_unit: 'mg', amount_taken: 1, amount_left: '70', last_picked_up: Date.today, icon: '<i class=\"fa-solid fa-tablets\"></i>', color: 'rgb(108, 160, 220)')
                User.find_by(email: 'test@gmail.com').medications.find_by(name: 'TestMed').medication_schedules.create(time: "11:30", day_of_week: 'Everyday', taken: false)
        end
        let!(:user) { User.find_by(email: 'test@gmail.com') }

        describe "POST /create" do
                before { 
                        session[:user_id] = user.id 
                }

                context 'with valid parameters' do
                        it 'has a :found status' do
                                post :create, params: { 
                                        user_id: user.id,
                                        day_taken: {
                                                date: Date.today, 
                                                taken: true, 
                                                user_id: user.id,
                                                medication_schedule_id: User.find_by(email: 'test@gmail.com').medications.find_by(name: 'TestMed').medication_schedules.first
                                        }
                                }  
                                expect(response).to have_http_status(:found)
                        end
                        it 'successfully creates a day taken' do
                                post :create, params: { 
                                        user_id: user.id,
                                        day_taken: {
                                                date: Date.today, 
                                                taken: true, 
                                                user_id: user.id,
                                                medication_schedule_id: User.find_by(email: 'test@gmail.com').medications.find_by(name: 'TestMed').medication_schedules.first
                                        }
                                }  

                                expect(user.day_takens.count).to eq(1)
                        end
                        it 'successfully redirects to the show day taken page' do
                                post :create, params: { 
                                        user_id: user.id,
                                        day_taken: {
                                                date: Date.today, 
                                                taken: true, 
                                                user_id: user.id,
                                                medication_schedule_id: User.find_by(email: 'test@gmail.com').medications.find_by(name: 'TestMed').medication_schedules.first
                                        }
                                } 
                                expect(response).to redirect_to(day_taken_url(user.day_takens.first))
                        end
                end
        end

        describe "PATCH /update" do
                before { 
                        session[:user_id] = user.id 
                        user.day_takens.create(date: Date.today, taken: true, medication_schedule_id: user.medications.find_by(name: 'TestMed').medication_schedules.first.id)
                }
                context 'with valid parameters' do
                        it 'has a :found status' do
                                patch :update, params: { 
                                        user_id: user.id,
                                        id: user.day_takens.first.id,
                                        day_taken: {
                                                date: Date.today, 
                                                taken: false, 
                                                user_id: user.id,
                                                medication_schedule_id: user.medications.find_by(name: 'TestMed').medication_schedules.first.id
                                        }
                                }  
                                expect(response).to have_http_status(:found)
                        end
                        it 'successfully updates a day taken' do
                                patch :update, params: { 
                                        user_id: user.id,
                                        id: user.day_takens.first.id,
                                        day_taken: {
                                                date: Date.today, 
                                                taken: false, 
                                                user_id: user.id,
                                                medication_schedule_id: user.medications.find_by(name: 'TestMed').medication_schedules.first.id
                                        }
                                }  
                                expect(user.day_takens.first.taken).to eq(false)
                        end
                        it 'successfully redirects to the show day taken page' do
                                patch :update, params: { 
                                        user_id: user.id,
                                        id: user.day_takens.first.id,
                                        day_taken: {
                                                date: Date.today, 
                                                taken: false, 
                                                user_id: user.id,
                                                medication_schedule_id: user.medications.find_by(name: 'TestMed').medication_schedules.first.id
                                        }
                                }  
                                expect(response).to redirect_to(day_taken_url(user.day_takens.first))
                        end
                end
        end

        describe 'DELETE /destroy' do
                before { 
                        session[:user_id] = user.id 
                        user.day_takens.create(date: Date.today, taken: true, medication_schedule_id: user.medications.find_by(name: 'TestMed').medication_schedules.first.id)
                }

                it 'has a successful status' do
                        delete :destroy, params: {
                                id: user.day_takens.first.id,
                        }
                        expect(response).to have_http_status(:found)
                end
                it 'deletes medication successfully' do
                        delete :destroy, params: {
                                id: user.day_takens.first.id,
                        }
                        expect(user.day_takens.count).to eq(0)
                end
                it 'redirects to user medications page' do
                        delete :destroy, params: {
                                id: user.day_takens.first.id,
                        }
                        expect(response).to redirect_to(day_takens_url)
                end
        end
end