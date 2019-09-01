FactoryBot.define do
	sequence(:user_seed) { |n| { username: "User#{n}", password: "password" } }

  factory :user, class: User do
    username { "JohnDoe" }
    password { "StronkPassword" }

    trait :blank_username do 
    	username { " " * 3 }
    end

    trait :invalid_username do
    	username { "A" * 33 }
    end

    trait :invalid_password do 
    	password { "A" * 73 }
    end

    trait :blank_password do
    	password { " " }
    end

    trait :invalid_confirmation do
    	password_confirmation { "NotStronkPassword" }
    end
  end

end