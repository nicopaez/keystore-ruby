require 'sinatra/base'
require 'sinatra/activerecord'
require './models/note.rb'
require 'json'
require 'omniauth'
require 'omniauth-twitter'

class MyApplication < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  enable :sessions


  #:nocov:
  configure :production,:staging do
    set :database, ENV['DATABASE_URL']
    @@provider = 'twitter'
    use OmniAuth::Builder do
      provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
    end
  end

  configure :development do
    set :database, 'sqlite:///notes-dev.db'
    @@provider = 'developer'
    use OmniAuth::Builder do
      provider :developer
    end
  end
  #:nocov:

  configure :test do
    set :database, 'sqlite:///notes-test.db'
    @@provider = 'developer'
    use OmniAuth::Builder do
      provider :developer
    end
    #ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Base.logger.level = Logger::ERROR
  end

  before do
    if request.path_info != "/auth/#{@@provider}/callback"
      redirect "/auth/#{@@provider}" unless session[:uid]
    end
  end

  get '/auth/:provider/callback' do
    session[:uid] = request.env['omniauth.auth']["uid"]
    session[:user_name] = request.env['omniauth.auth']["info"]["name"]
    redirect '/'
  end

  post '/auth/:provider/callback' do
    session[:uid] = request.env['omniauth.auth']["uid"]
    session[:user_name] = request.env['omniauth.auth']["info"]["name"]
    redirect '/'
  end

  get '/' do
    erb :application
  end

  get '/search' do
    key = params[:key]
    note = Note.find_by_key_and_user(key, session[:uid])
    if (note.nil?)
      return status(404)
    else
      content_type('application/json')
      return {:key => note.key, :value => note.value, :id => note.id}.to_json
    end
  end

  post '/new' do
    key = params[:key]
    note = Note.find_by_key_and_user(key, session[:uid])
    if(note.nil?)
      note = Note.new
      note.key = key
      note.value = params[:value]
      note.user = session[:uid]
      note.save
      return 'success'
    else
      return 'Duplicated key'
    end
  end

  post '/:id' do
    # update the specified note
  end

end
