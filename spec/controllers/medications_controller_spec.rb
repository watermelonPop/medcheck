require 'rails_helper'

RSpec.describe MedicationsController do
        before do
                User.destroy_all
                User.create({ first_name: 'Test', last_name: 'Test', email: 'test@gmail.com' })
                User.find_by(email: 'test@gmail.com').medications.create(name: 'TestMed', dose_amount: 100, dose_unit: 'mg', amount_taken: 1, amount_left: '70', last_picked_up: Date.today, icon: '<i class=\"fa-solid fa-tablets\"></i>', color: 'rgb(108, 160, 220)')
                User.find_by(email: 'test@gmail.com').medications.find_by(name: 'TestMed').medication_schedules.create(time: "11:30", day_of_week: 'Everyday', taken: false)
        end
        let!(:user) { User.find_by(email: 'test@gmail.com') }

        describe "GET /index" do
                before { session[:user_id] = user.id }
                it 'loads the users medications page' do
                        get :index, params: { user_id: user.id }
                        expect(response).to have_http_status(:success)
                        expect(response).to render_template(:index)
                end
        end

        describe "GET /show" do
                before { session[:user_id] = user.id }
                it 'loads the medication page' do
                        get :show, params: { user_id: user.id, id: user.medications.find_by(name: 'TestMed').id }
                        expect(response).to have_http_status(:success)
                        expect(response).to render_template(:show)
                end

                it 'correctly calculates the next pick up date' do
                        get :show, params: { user_id: user.id, id: user.medications.find_by(name: 'TestMed').id }
                        expect(assigns(:predicted_date)).to eq(Date.today + user.medications.find_by(name: 'TestMed').amount_left.to_i)
                end

                it 'gets medications schedules' do
                        get :show, params: { user_id: user.id, id: user.medications.find_by(name: 'TestMed').id }
                        expect(assigns(:schedules)).to eq(user.medications.find_by(name: 'TestMed').medication_schedules)
                end
        end

        describe 'GET /new' do
                before { session[:user_id] = user.id }
                it 'loads the new medication form' do
                        get :new, params: { user_id: user.id }
                        expect(response).to have_http_status(:success)
                        expect(response).to render_template(:new)
                end
        end

        describe 'POST /create' do
                before { session[:user_id] = user.id }
                it 'successfully creates a new medication and redirects' do
                        user.medications.find_by(name: 'TestMed')&.destroy
                    
                        expect {
                          post :create, params: { 
                            user_id: user.id, 
                            medication: {
                              name: 'TestMed', 
                              dose_amount: 100, 
                              dose_unit: 'mg', 
                              amount_taken: 1, 
                              amount_left: '70', 
                              last_picked_up: Date.today, 
                              icon: '<i class="fa-solid fa-tablets"></i>', 
                              color: 'rgb(108, 160, 220)'
                            }
                          }
                        }.to change(user.medications, :count).by(1)

                        expect(response).to redirect_to(user_medications_path(user_id: user.id))
                end

                it 'fails to creates medication due to missing name' do
                        post :create, params: { 
                                          user_id: user.id, 
                                          medication: { 
                                            dose_amount: 100, 
                                            dose_unit: 'mg', 
                                            amount_taken: 1, 
                                            amount_left: '70', 
                                            last_picked_up: Date.today, 
                                            icon: '<i class="fa-solid fa-tablets"></i>', 
                                            color: 'rgb(108, 160, 220)'
                                          }
                        }
                        expect(response).to have_http_status(:unprocessable_entity)
                        expect(response).to render_template(:new)
                end

                it 'fails to creates medication due to missing dose amount' do
                        post :create, params: { 
                                          user_id: user.id, 
                                          medication: { 
                                                name: 'TestMed', 
                                            dose_unit: 'mg', 
                                            amount_taken: 1, 
                                            amount_left: '70', 
                                            last_picked_up: Date.today, 
                                            icon: '<i class="fa-solid fa-tablets"></i>', 
                                            color: 'rgb(108, 160, 220)'
                                          }
                        }
                        expect(response).to have_http_status(:unprocessable_entity)
                        expect(response).to render_template(:new)
                end

                it 'fails to creates medication due to missing dose unit' do
                        post :create, params: { 
                                          user_id: user.id, 
                                          medication: { 
                                                name: 'TestMed', 
                                                dose_amount: 100,
                                            amount_taken: 1, 
                                            amount_left: '70', 
                                            last_picked_up: Date.today, 
                                            icon: '<i class="fa-solid fa-tablets"></i>', 
                                            color: 'rgb(108, 160, 220)'
                                          }
                        }
                        expect(response).to have_http_status(:unprocessable_entity)
                        expect(response).to render_template(:new)
                end

                it 'fails to creates medication due to missing amount taken' do
                        post :create, params: { 
                                          user_id: user.id, 
                                          medication: { 
                                                name: 'TestMed',
                                            dose_amount: 100, 
                                            dose_unit: 'mg', 
                                            amount_left: '70', 
                                            last_picked_up: Date.today, 
                                            icon: '<i class="fa-solid fa-tablets"></i>', 
                                            color: 'rgb(108, 160, 220)'
                                          }
                        }
                        expect(response).to have_http_status(:unprocessable_entity)
                        expect(response).to render_template(:new)
                end

                it 'fails to creates medication due to amount left' do
                        post :create, params: { 
                                          user_id: user.id, 
                                          medication: { 
                                                name: 'TestMed',
                                            dose_amount: 100, 
                                            dose_unit: 'mg', 
                                            amount_taken: 1, 
                                            last_picked_up: Date.today, 
                                            icon: '<i class="fa-solid fa-tablets"></i>', 
                                            color: 'rgb(108, 160, 220)'
                                          }
                        }
                        expect(response).to have_http_status(:unprocessable_entity)
                        expect(response).to render_template(:new)
                end

                it 'fails to creates medication due to missing last pickup' do
                        post :create, params: { 
                                          user_id: user.id, 
                                          medication: { 
                                                name: 'TestMed',
                                            dose_amount: 100, 
                                            dose_unit: 'mg', 
                                            amount_taken: 1, 
                                            amount_left: '70', 
                                            icon: '<i class="fa-solid fa-tablets"></i>', 
                                            color: 'rgb(108, 160, 220)'
                                          }
                        }
                        expect(response).to have_http_status(:unprocessable_entity)
                        expect(response).to render_template(:new)
                end

                it 'fails to creates medication due to missing icon' do
                        post :create, params: { 
                                          user_id: user.id, 
                                          medication: { 
                                                name: 'TestMed',
                                            dose_amount: 100, 
                                            dose_unit: 'mg', 
                                            amount_taken: 1, 
                                            amount_left: '70', 
                                            last_picked_up: Date.today, 
                                            color: 'rgb(108, 160, 220)'
                                          }
                        }
                        expect(response).to have_http_status(:unprocessable_entity)
                        expect(response).to render_template(:new)
                end

                it 'fails to creates medication due to missing color' do
                        post :create, params: { 
                                          user_id: user.id, 
                                          medication: { 
                                                name: 'TestMed',
                                            dose_amount: 100, 
                                            dose_unit: 'mg', 
                                            amount_taken: 1, 
                                            amount_left: '70', 
                                            last_picked_up: Date.today, 
                                            icon: '<i class="fa-solid fa-tablets"></i>'
                                          }
                        }
                        expect(response).to have_http_status(:unprocessable_entity)
                        expect(response).to render_template(:new)
                end
        end     

        describe 'PATCH /update' do
                before { session[:user_id] = user.id }
                context 'with valid parameters' do
                        it 'successfully updates a medication' do
                                patch :update, params: { 
                                user_id: user.id, 
                                        id: user.medications.find_by(name: 'TestMed').id,
                                medication: {
                                name: 'TestMed2', 
                                dose_amount: 100, 
                                dose_unit: 'mg', 
                                amount_taken: 1, 
                                amount_left: '70', 
                                last_picked_up: Date.today, 
                                icon: '<i class="fa-solid fa-tablets"></i>', 
                                color: 'rgb(108, 160, 220)'
                                }
                                }

                                expect(user.medications.find_by(name: 'TestMed2')).to be_present
                                expect(user.medications).to include(user.medications.find_by(name: 'TestMed2'))
                        end
                        it 'successfully redirects to the show medication page' do
                                patch :update, params: { 
                                        user_id: user.id, 
                                        id: user.medications.find_by(name: 'TestMed').id,
                                        medication: {
                                        name: 'TestMed2', 
                                        dose_amount: 100, 
                                        dose_unit: 'mg', 
                                        amount_taken: 1, 
                                        amount_left: '70', 
                                        last_picked_up: Date.today, 
                                        icon: '<i class="fa-solid fa-tablets"></i>', 
                                        color: 'rgb(108, 160, 220)'
                                        }
                                }
                                expect(response).to redirect_to(user_medication_path(user_id: user.id, id: user.medications.find_by(name: 'TestMed2').id))
                        end
                end

                context 'with invalid parameters' do
                                
                        it 'fails to update medication due to missing name' do
                                patch :update, params: { 
                                        user_id: user.id, 
                                        id: user.medications.find_by(name: 'TestMed').id,
                                        medication: {
                                                name: '',
                                        dose_amount: 100, 
                                        dose_unit: 'mg', 
                                        amount_taken: 1, 
                                        amount_left: '70', 
                                        last_picked_up: Date.today, 
                                        icon: '<i class="fa-solid fa-tablets"></i>', 
                                        color: 'rgb(108, 160, 220)'
                                        }
                                }
                                expect(response).to have_http_status(:unprocessable_entity)
                                expect(response).to render_template(:edit)
                        end

                        it 'fails to update medication due to missing dose amount' do
                                patch :update, params: { 
                                        user_id: user.id, 
                                        id: user.medications.find_by(name: 'TestMed').id,
                                        medication: {
                                        name: 'TestMed', 
                                        dose_amount: '',
                                        dose_unit: 'mg', 
                                        amount_taken: 1, 
                                        amount_left: '70', 
                                        last_picked_up: Date.today, 
                                        icon: '<i class="fa-solid fa-tablets"></i>', 
                                        color: 'rgb(108, 160, 220)'
                                        }
                                }
                                expect(response).to have_http_status(:unprocessable_entity)
                                expect(response).to render_template(:edit)
                        end

                        it 'fails to update medication due to missing dose unit' do
                                patch :update, params: { 
                                        user_id: user.id, 
                                        id: user.medications.find_by(name: 'TestMed').id,
                                        medication: {
                                        name: 'TestMed', 
                                        dose_amount: 100, 
                                        dose_unit: '',
                                        amount_taken: 1, 
                                        amount_left: '70', 
                                        last_picked_up: Date.today, 
                                        icon: '<i class="fa-solid fa-tablets"></i>', 
                                        color: 'rgb(108, 160, 220)'
                                        }
                                }
                                expect(response).to have_http_status(:unprocessable_entity)
                                expect(response).to render_template(:edit)
                        end

                        it 'fails to update medication due to missing amount taken' do
                                patch :update, params: { 
                                        user_id: user.id, 
                                        id: user.medications.find_by(name: 'TestMed').id,
                                        medication: {
                                        name: 'TestMed', 
                                        dose_amount: 100, 
                                        dose_unit: 'mg', 
                                        amount_taken: '',
                                        amount_left: '70', 
                                        last_picked_up: Date.today, 
                                        icon: '<i class="fa-solid fa-tablets"></i>', 
                                        color: 'rgb(108, 160, 220)'
                                        }
                                }
                                expect(response).to have_http_status(:unprocessable_entity)
                                expect(response).to render_template(:edit)
                        end

                        it 'fails to update medication due to amount left' do
                                patch :update, params: { 
                                        user_id: user.id, 
                                        id: user.medications.find_by(name: 'TestMed').id,
                                        medication: {
                                        name: 'TestMed', 
                                        dose_amount: 100, 
                                        dose_unit: 'mg', 
                                        amount_taken: 1, 
                                        amount_left: '', 
                                        last_picked_up: Date.today, 
                                        icon: '<i class="fa-solid fa-tablets"></i>', 
                                        color: 'rgb(108, 160, 220)'
                                        }
                                }
                                expect(response).to have_http_status(:unprocessable_entity)
                                expect(response).to render_template(:edit)
                        end

                        it 'fails to update medication due to missing last pickup' do
                                patch :update, params: { 
                                        user_id: user.id, 
                                        id: user.medications.find_by(name: 'TestMed').id,
                                        medication: {
                                        name: 'TestMed2', 
                                        dose_amount: 100, 
                                        dose_unit: 'mg', 
                                        amount_taken: 1, 
                                        amount_left: '70', 
                                        last_picked_up: '',
                                        icon: '<i class="fa-solid fa-tablets"></i>', 
                                        color: 'rgb(108, 160, 220)'
                                        }
                                }
                                expect(response).to have_http_status(:unprocessable_entity)
                                expect(response).to render_template(:edit)
                        end

                        it 'fails to update medication due to missing icon' do
                                patch :update, params: { 
                                        user_id: user.id, 
                                        id: user.medications.find_by(name: 'TestMed').id,
                                        medication: {
                                        name: 'TestMed', 
                                        dose_amount: 100, 
                                        dose_unit: 'mg', 
                                        amount_taken: 1, 
                                        amount_left: '70', 
                                        last_picked_up: Date.today, 
                                        icon: '',
                                        color: 'rgb(108, 160, 220)'
                                        }
                                }
                                expect(response).to have_http_status(:unprocessable_entity)
                                expect(response).to render_template(:edit)
                        end

                        it 'fails to update medication due to missing color' do
                                patch :update, params: { 
                                        user_id: user.id, 
                                        id: user.medications.find_by(name: 'TestMed').id,
                                        medication: {
                                        name: 'TestMed2', 
                                        dose_amount: 100, 
                                        dose_unit: 'mg', 
                                        amount_taken: 1, 
                                        amount_left: '70', 
                                        last_picked_up: Date.today, 
                                        icon: '<i class="fa-solid fa-tablets"></i>',
                                        color: '',
                                        }
                                }
                                expect(response).to have_http_status(:unprocessable_entity)
                                expect(response).to render_template(:edit)
                        end
                end
        end

        describe 'DELETE /destroy' do
                before { session[:user_id] = user.id }
                it 'has a successful status' do
                        user.medications.create(name: 'TestMed2', dose_amount: 100, dose_unit: 'mg', amount_taken: 1, amount_left: '70', last_picked_up: Date.today, icon: '<i class=\"fa-solid fa-tablets\"></i>', color: 'rgb(108, 160, 220)')
                        delete :destroy, params: {user_id: user.id, id: user.medications.find_by(name: 'TestMed2').id}
                        expect(response).to have_http_status(:found)
                end
                it 'deletes medication successfully' do
                        user.medications.create(name: 'TestMed2', dose_amount: 100, dose_unit: 'mg', amount_taken: 1, amount_left: '70', last_picked_up: Date.today, icon: '<i class=\"fa-solid fa-tablets\"></i>', color: 'rgb(108, 160, 220)')
                        delete :destroy, params: {user_id: user.id, id: user.medications.find_by(name: 'TestMed2').id}
                        expect(user.medications.count).to eq(1)
                end
                it 'redirects to user medications page' do
                        user.medications.create(name: 'TestMed2', dose_amount: 100, dose_unit: 'mg', amount_taken: 1, amount_left: '70', last_picked_up: Date.today, icon: '<i class=\"fa-solid fa-tablets\"></i>', color: 'rgb(108, 160, 220)')
                        delete :destroy, params: {user_id: user.id, id: user.medications.find_by(name: 'TestMed2').id}
                        expect(response).to redirect_to(user_medications_path(user_id: user.id))
                end
        end

        describe 'GET /new_pickup' do
                before { session[:user_id] = user.id }
                it 'redirects to the medication individual page' do
                        get :new_pickup, params: {user_id: user.id, medication_id: user.medications.find_by(name: 'TestMed').id, date: Date.today, amount: 5}
                        expect(response).to redirect_to(user_medication_path(user_id: user.id, id: user.medications.find_by(name: 'TestMed').id))
                end
                it 'updates the amount left' do
                        get :new_pickup, params: {user_id: user.id, medication_id: user.medications.find_by(name: 'TestMed').id, date: Date.today, amount: 5}
                        expect(user.medications.find_by(name: 'TestMed').amount_left).to eq(75)
                end
                it 'updates the last picked up' do
                        get :new_pickup, params: {user_id: user.id, medication_id: user.medications.find_by(name: 'TestMed').id, date: Date.today, amount: 5}
                        expect(user.medications.find_by(name: 'TestMed').last_picked_up).to eq(Date.today)
                end
        end
end

