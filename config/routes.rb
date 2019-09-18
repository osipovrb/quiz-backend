Rails.application.routes.draw do

	resources :users, only: [:index, :create] do
		delete 'drop', on: :collection
	end

	post 'login', to: 'authorization#login'
	delete 'logout', to: 'authorization#logout'
	get 'session', to: 'authorization#session'

	mount ActionCable.server => '/cable'

end
