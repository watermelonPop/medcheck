require 'rails_helper'

RSpec.describe SessionsController do
        let(:auth_hash) do
                OmniAuth::AuthHash.new({
                  'provider' => 'google_oauth2',
                  'uid' => '123456',
                  'info' => {
                    'email' => 'john.doe@gmail.com',
                    'name' => 'John Doe'
                  }
                })
        end
        before do
                OmniAuth.config.test_mode = true
                OmniAuth.config.mock_auth[:google_oauth2] = auth_hash
                request.env['omniauth.auth'] = auth_hash
                User.create({ first_name: 'Test', last_name: 'Test', email: 'test@gmail.com' })
        end

        describe '#omniauth' do
                context 'when user does not exist' do
                        it 'creates a new user' do
                                expect {
                                get :omniauth, params: { provider: 'google_oauth2' }
                                }.to change(User, :count).by(1)
                        end
                        it 'sets user attributes correctly' do
                                get :omniauth, params: { provider: 'google_oauth2' }
                                user = User.last
                                expect(user.email).to eq('john.doe@gmail.com')
                                expect(user.first_name).to eq('John')
                                expect(user.last_name).to eq('Doe')
                                expect(user.uid).to eq('123456')
                                expect(user.provider).to eq('google_oauth2')
                        end
                
                        it 'sets session and redirects to dashboard' do
                                get :omniauth, params: { provider: 'google_oauth2' }
                                expect(session[:user_id]).to eq(User.last.id)
                                expect(response).to redirect_to(user_dashboard_index_path(user_id: User.last.id))
                                expect(flash[:notice]).to eq('You are logged in.')
                        end
                end
    
                context 'when user already exists' do
                        let!(:existing_user) do
                                User.create!(
                                email: 'john.doe@gmail.com',
                                first_name: 'John',
                                last_name: 'Doe',
                                uid: '123456',
                                provider: 'google_oauth2'
                                )
                        end
        
                        it 'does not create a new user' do
                                expect {
                                get :omniauth, params: { provider: 'google_oauth2' }
                                }.not_to change(User, :count)
                        end
        
                        it 'sets session and redirects to dashboard' do
                                get :omniauth, params: { provider: 'google_oauth2' }
                                expect(session[:user_id]).to eq(existing_user.id)
                                expect(response).to redirect_to(user_dashboard_index_path(user_id: existing_user.id))
                                expect(flash[:notice]).to eq('You are logged in.')
                        end
                end
    
                context 'when user is invalid' do
                        before do
                                allow_any_instance_of(User).to receive(:valid?).and_return(false)
                        end
                
                        it 'redirects to welcome path' do
                                get :omniauth, params: { provider: 'google_oauth2' }
                                expect(response).to redirect_to(welcome_path)
                                expect(flash[:alert]).to eq('Login failed.')
                        end
                
                        it 'does not set session' do
                                get :omniauth, params: { provider: 'google_oauth2' }
                                expect(session[:user_id]).to be_nil
                        end
                end
        end

        describe '#logout' do
                let!(:user) { User.find_by(email: 'test@gmail.com') }
                context 'when a user is logged in' do
                        before do
                                # Simulate a logged-in user by setting a user_id in the session
                                session[:user_id] = user.id
                        end
                
                        it 'clears the session' do
                                get :logout
                                expect(session[:user_id]).to be_nil
                        end
        
                        it 'redirects to the welcome path' do
                                get :logout
                                expect(response).to redirect_to(welcome_path)
                        end
                end
        
                context 'when no user is logged in' do
                        it 'redirects to the welcome path' do
                                get :logout
                                expect(response).to redirect_to(welcome_path)
                        end
                end
      end    
end