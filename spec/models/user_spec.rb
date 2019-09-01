# TODO: DRY via shared modules
require 'rails_helper'

RSpec.describe User, type: :model do
	describe "validations" do
		it { should validate_presence_of(:username) }
		it { should validate_uniqueness_of(:username) }
		it { should validate_length_of(:username).is_at_most(32) }

		it { should have_secure_password }
		it { should validate_presence_of(:password) }
		it { should validate_length_of(:password).is_at_most(72) }
	end
end
