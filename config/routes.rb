Rails.application.routes.draw do

  get 'serial', to: 'arduino#serial'
  post 'run_serial', to: 'arduino#run_serial'

  get 'firmata', to: 'arduino#firmata'
  post 'connect_firmata', to: 'arduino#connect_firmata'
  post 'run_firmata', to: 'arduino#run_firmata'

  root 'arduino#serial'

end
