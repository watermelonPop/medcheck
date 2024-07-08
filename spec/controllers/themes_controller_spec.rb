require 'rails_helper'

RSpec.describe ThemesController do
        before do
                User.destroy_all
                User.create({ first_name: 'Test', last_name: 'Test', email: 'test@gmail.com' })
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
                                        theme: { 
                                                name: "Test" ,
                                                main_background: "#FFE5D9", 
                                                schedule_background: "#D8E2DC", 
                                                medication_background: "#F4ACB7", 
                                                medication_main: "#FFCAD4", 
                                                heading: "#9D8189", 
                                                font: "Gamja Flower"
                                        }
                                }  
                                expect(response).to have_http_status(:found)
                        end
                        it 'successfully creates a medication schedule' do
                                expect{
                                post :create, params: { 
                                        user_id: user.id, 
                                        theme: { 
                                                name: "Test" ,
                                                main_background: "#FFE5D9", 
                                                schedule_background: "#D8E2DC", 
                                                medication_background: "#F4ACB7", 
                                                medication_main: "#FFCAD4", 
                                                heading: "#9D8189", 
                                                font: "Gamja Flower"
                                        }
                                }  }.to change(user.themes, :count).by(1)
                        end
                        it 'successfully redirects to the show medication page' do
                                post :create, params: { 
                                        user_id: user.id, 
                                        theme: { 
                                                name: "Test" ,
                                                main_background: "#FFE5D9", 
                                                schedule_background: "#D8E2DC", 
                                                medication_background: "#F4ACB7", 
                                                medication_main: "#FFCAD4", 
                                                heading: "#9D8189", 
                                                font: "Gamja Flower"
                                        }
                                }  
                                expect(response).to redirect_to(user_path(user))
                        end
                end
        end

        describe 'DELETE /destroy' do
                before { 
                        session[:user_id] = user.id 
                        user.themes.create(name: "Test" ,
                        main_background: "#FFE5D9", 
                        schedule_background: "#D8E2DC", 
                        medication_background: "#F4ACB7", 
                        medication_main: "#FFCAD4", 
                        heading: "#9D8189", 
                        font: "Gamja Flower")
                }
                it 'has a successful status' do
                        delete :destroy, params: {
                                user_id: user.id, 
                                id: user.themes.find_by(name: "Test")
                        }
                        expect(response).to have_http_status(:found)
                end
                it 'deletes medication successfully' do
                        expect{
                        delete :destroy, params: {
                                user_id: user.id, 
                                id: user.themes.find_by(name: "Test")
                        }}.to change(user.themes, :count).by(-1)
                end
                it 'redirects to user medications page' do
                        delete :destroy, params: {
                                user_id: user.id, 
                                id: user.themes.find_by(name: "Test")
                        }
                        expect(response).to redirect_to(user_path(user))
                end
        end
end