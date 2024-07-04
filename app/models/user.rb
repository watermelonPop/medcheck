class User < ApplicationRecord
        validates :email, presence: true
        has_many :medications, dependent: :destroy
        has_many :day_takens, dependent: :destroy
        has_many :themes, dependent: :destroy
        belongs_to :current_theme, class_name: 'Theme', optional: true

        after_create :set_default_current_theme

        private

        def set_default_current_theme
                self.themes.create(name: 'tteok', main_background: '#FFE5D9', schedule_background: '#D8E2DC', medication_background: '#F4ACB7', medication_main: '#FFCAD4', heading: '#9D8189', font: 'Gamja Flower')
                self.themes.create(name: 'dabadeedabadi', main_background: '#CCDBDC', schedule_background: '#80CED7', medication_background: '#007EA7', medication_main: '#9AD1D4', heading: '#003249', font: 'Quicksand')
                self.themes.create(name: 'tea', main_background: '#D0D6B0', schedule_background: '#4B644A', medication_background: '#EDCECA', medication_main: '#734B5E', heading: '#587B7F', font: 'Crimson Pro')
                self.themes.create(name: 'strawberry', main_background: '#FFBCB5', schedule_background: '#D8DEBA', medication_background: '#F6838C', medication_main: '#417B5A', heading: '#BC4B51', font: 'Chivo Mono')
                if self.themes.any?
                        update(current_theme: self.themes.first)
                end
        end
end
