Falgun::Application.routes.draw do

  resources :log_errors


  resources :logs


  devise_for :users

  root :to => "home#index"

  namespace :api do
    scope :module => 'v1', :constraints => ApiConstraints.new(:version => 1, :default => true) do
      resources :logs, :constraints => { :id => /.*/ }
    end
  end

end
