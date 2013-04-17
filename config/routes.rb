Lgdsf::Application.routes.draw do

  devise_for :users, :controllers => {:sessions => 'users', :omniauth_callbacks => 'omniauth_callbacks', :registrations => 'registrations'}

  root :to => "staffs#index"

  match '/staffs/index_department' => 'staffs#index_department'

  match '/staffs/position' => 'staffs#position_form'
  match '/staffs/save_position'
  match '/staffs/destination' => 'staffs#destination_form'
  match '/staffs/save_destination'
  match '/staffs/send/:disaster_code' => 'staffs#send_form', :as => "staffs_send"
  match '/staffs/save_send'
end
