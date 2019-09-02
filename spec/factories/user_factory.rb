FactoryBot.define do
	sequence(:username_seed) { |n| "User#{n}" }

  factory :user, class: User do
    username { "JohnDoe" }
    password { "StronkPassword" }
    token { SecureRandom.base58(24) }

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