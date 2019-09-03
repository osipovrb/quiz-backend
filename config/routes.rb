Rails.application.routes.draw do

	resources :users, only: [:index, :create] do
		delete 'drop', on: :collection
	end

	get 'protected/index', to: 'protected#index'
	get 'protected/echo', to: 'protected#echo'

	post 'login', to: 'authorization#login'
	delete 'logout', to: 'authorization#logout'

end
