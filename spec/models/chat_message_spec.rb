require 'rails_helper'

RSpec.describe ChatMessage, type: :model do
	describe "validations" do
		it { should validate_presence_of(:content) }
		it { should validate_length_of(:content).is_at_most(500) }

		it { should belong_to(:user) }
	end
end
