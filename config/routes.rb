Rails.application.routes.draw do

	resources :users, only: [:index, :create] do
		delete 'drop', on: :collection
	end

end
