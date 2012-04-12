MultiModelTest::Application.routes.draw do
  resources :dog_walkers
  root :to => "dog_walkers#index"
end
