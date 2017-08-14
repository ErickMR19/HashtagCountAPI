class TwitterClientController < ApplicationController
  def hashtag_count
    @twt_consumer_key_value = Setting.twitter_consumer_key
    @twt_consumer_secret_value = Setting.twitter_consumer_secret
    @twt_bearer_token = Setting.twitter_bearer_token || ''
    hashtag = params[:hashtag]
    response = {}
    status_code = :ok
    # verifica que lo enviado existe y sea unicamente una palabra
    if hashtag.split.length != 1 
      response[:error] = "The hashtag is mandatory, and must not be empty, and can't contain any spaces"
      status_code = :unprocessable_entity
    # verifica que ambos valores de configuración hayan sido agregados      
    elsif @twt_consumer_key_value == '' || @twt_consumer_secret_value == '' 
      response[:error] =  'Bad configuration, please visit the admin panel and insert both keys'
      status_code = :internal_server_error
    else
      # obtiene los parametros opcionales de la consulta
      options = {}
      result_type = params[:result_type]
      lang = params[:lang]
      until_p = params[:until]
      options[:result_type] = result_type || 'recent'
      options[:lang] = lang if lang
      options[:until] = until_p if until_p
  
      # obtiene los parametros de configuracion
      config = {
        consumer_key:    @twt_consumer_key_value,
        consumer_secret: @twt_consumer_secret_value
      }
      # crea el cliente
      client = Twitter::REST::Client.new(config)
  
      # utiliza el bearer_token si ya existe, para evitar solicitarlo
      client.bearer_token = @twt_bearer_token if @twt_bearer_token != ""
      
      # bandera de verificacion, para que si el bearer token es invalido primero lo solicite antes de devolver un error
      continue = -1
      begin
        continue += 1
        number_result = client.search("##{hashtag}", options).attrs[:statuses].length
        response[:number_tweets] = number_result        
        # guarda el bearer_token en las propiedades del sitio
        Setting.twitter_bearer_token = client.bearer_token.to_s unless @twt_bearer_token != '' 
      rescue Twitter::Error::Unauthorized => e
        # Invalid bearer token
        # borra el bearer token para que el cliente solicite otro
        @twt_bearer_token = ''
        client.bearer_token = nil
        continue += 1  
      rescue Twitter::Error::Forbidden => e
        # Invalid credentials
        # borra el bearer token de las propiedades del sitio
        Setting.twitter_bearer_token = nil
        response[:error] = 'invalid credentials'
        code = :unauthorized
      rescue Twitter::Error::NotFound => e
        # TWT NOT FOUND
        response[:error] = 'Se produjo un error, no se pudo comunicar con Twitter'
        code = :not_found
      rescue => e
        # Error no identificado
        response[:error] = 'Se produjo un error, por favor intente mas tarde o repórtelo al encargado'
        code = :internal_server_error
      end while continue == 1
    end
    render json: response, status: status_code
  end
end
