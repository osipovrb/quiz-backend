Rails.application.routes.draw do

	resources :users, only: [:index, :create] do
		delete 'drop', on: :collection
		post 'login', on: :collection
		delete 'logout', on: :collection
	end

	get 'protected/index', to: 'protected#index'
	get 'protected/echo', to: 'protected#echo'

end
