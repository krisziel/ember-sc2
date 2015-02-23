Rails.application.routes.draw do
  root 'player#index'
  get 'player/profile/:id' => 'player#profile'
end
