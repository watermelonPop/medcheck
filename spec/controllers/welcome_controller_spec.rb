require 'rails_helper'

RSpec.describe WelcomeController do
        before do
                User.destroy_all
                User.create({ first_name: 'Test', last_name: 'Test', email: 'test@gmail.com' })
                User.create({ first_name: 'Fake', last_name: 'Name', email: 'fakename@gmail.com' })
                User.create({ first_name: 'Shakira', last_name: 'Shakira', email: 'shakira@gmail.com' })
                User.create({ first_name: 'Charli', last_name: 'XCX', email: 'brat@gmail.com' })
                User.create({ first_name: 'simone', last_name: 'kang', email: 'simonemykang@gmail.com' })
        end
        context "when user is not logged in" do
                describe "GET /index" do
                        it 'loads the login page' do
                                allow(controller).to receive(:logged_in?).and_return(false)
                                get :index
                                expect(response).to have_http_status(:success)
                                expect(response).to render_template(:index)
                        end
                end
        end
        context "when user is logged in" do
                let!(:user) { User.find_by(email: 'test@gmail.com') }
                
                describe "GET /index" do
                        before { session[:user_id] = user.id }
                
                        it 'loads the login page' do
                                get :index
                                expect(response).to redirect_to(user_path(user))
                        end
                end
        end
end