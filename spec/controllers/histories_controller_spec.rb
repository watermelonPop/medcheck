require 'rails_helper'

RSpec.describe HistoriesController do
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
                        get :index, params: { user_id: user.id}
                        expect(response).to render_template(:index)
                end
                it 'returns ok status' do
                        get :index, params: { user_id: user.id}
                        expect(response).to have_http_status(:ok)
                end
                it 'sets the medication schedules variable' do
                        get :index, params: { user_id: user.id}
                        expect(assigns(:unique_days)).to eq(user.day_takens.uniq.pluck(:date))
                end
        end

        describe 'GET get_history_day_history' do
                before { session[:user_id] = user.id }
                it 'has ok status' do
                        get :get_history_day_schedules, params: {
                                user_id: user.id,
                                date_needed: Date.today
                        }
                        expect(response).to have_http_status(:ok)
                end
                it 'sets days taken' do
                        get :get_history_day_schedules, params: {
                                user_id: user.id,
                                date_needed: Date.today
                        }
                        expect(assigns(:days_taken)).to eq(user.day_takens.where(date: Date.today))
                end
        end
end