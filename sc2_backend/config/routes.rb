Rails.application.routes.draw do
  root 'player#index'

  get 'player/profile/:id' => 'player#profile'
  get 'player/profile/:name/:realm/:bnetid/add' => 'player#save_player'
end
