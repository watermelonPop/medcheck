require 'rails_helper'

RSpec.describe UsersController do
  before do
    User.destroy_all
    User.create({ first_name: 'Test', last_name: 'Test', email: 'test@gmail.com' })
    User.create({ first_name: 'Fake', last_name: 'Name', email: 'fakename@gmail.com' })
    User.create({ first_name: 'Shakira', last_name: 'Shakira', email: 'shakira@gmail.com' })
    User.create({ first_name: 'Charli', last_name: 'XCX', email: 'brat@gmail.com' })
    User.create({ first_name: 'simone', last_name: 'kang', email: 'simonemykang@gmail.com' })
  end

  let!(:user) { User.find_by(email: 'test@gmail.com') }

  describe "GET /show" do
    before { session[:user_id] = user.id }

    it 'loads the page with the correct user' do
      get :show, params: { id: user.id }
      expect(assigns(:user)).to eq(User.find_by(id: user.id))
    end
  end

  describe "set user's current theme" do
    before { session[:user_id] = user.id }
    it 'correctly sets the theme' do
      get :set_current_theme, params: { user_id: user.id, theme_id: user.themes.first.id }
      expect(user.current_theme_id ).to eq(user.themes.first.id)
    end

    it 'redirects to user#show page' do
      get :set_current_theme, params: {user_id: user.id, theme_id: user.themes.first.id }
      expect(response).to redirect_to(user_path(user.id))
    end
  end
end
