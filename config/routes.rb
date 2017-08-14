Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # ruta para la pagina inicial
  root to: 'pages#home'
  # ruta para la pagina de documentacion
  get 'documentation', to: 'pages#doc', as: :doc
  # ruta para la pagina de configuracion
  get 'config', to: 'pages#configuration_panel', as: :config
  # ruta para guardar cambios en las configuraciones
  patch 'settings/:setting', to: 'settings#update', as: :setting_update
  # ruta provista para el API
  get 'tweets/:hashtag', action: :hashtag_count, controller: 'twitter_client', as: :hashtag_count
end
