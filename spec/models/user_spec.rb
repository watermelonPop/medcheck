require 'rails_helper'

RSpec.describe User, type: :model do
        before do
                User.destroy_all
        end

        describe "set_default_current_theme" do
                it "creates 4 initial themes" do
                        User.create({ first_name: 'Test', last_name: 'Test', email: 'test@gmail.com' })
                        expect(User.find_by(email: 'test@gmail.com').themes.count).to eq(4)
                end
                it 'sets the current theme to the first theme in the list' do
                        User.create({ first_name: 'Test', last_name: 'Test', email: 'test@gmail.com' })
                        expect(User.find_by(email: 'test@gmail.com').current_theme).to eq(User.find_by(email: 'test@gmail.com').themes.first)
                end
        end
end