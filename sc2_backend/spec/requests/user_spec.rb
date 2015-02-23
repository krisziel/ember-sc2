require 'rails_helper'

describe 'user request#' do

  xit 'expects to be logged out' do
    post '/user/autologin',
    {
      game_id:1
    }
    login = JSON.parse(response.body)
    expect(login["status"]).to eq('loggedout')
  end

end
