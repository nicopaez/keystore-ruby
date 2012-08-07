require 'sinatra/base'
require 'sinatra/activerecord'
require './models/note.rb'
require 'json'
require 'omniauth'
require 'omniauth-twitter'

class MyApplication < Sinatra::Base

  register Sinatra::ActiveRecordExtension
  enable :sessions

  configure :production,:staging do
    set :database, ENV['DATABASE_URL']
    use OmniAuth::Builder do
      provider :developer
    end
  end

  configure :development do
    set :database, 'sqlite:///notes-dev.db'
    use OmniAuth::Builder do
      provider :developer
    end
  end

  configure :test do
    set :database, 'sqlite:///notes-test.db'
    use OmniAuth::Builder do
      provider :developer
    end
  end

  before do
    if request.path_info != '/auth/developer/callback'
      redirect '/auth/developer' unless session[:uid]
    end
  end

  post '/auth/developer/callback' do
    session[:uid] = request.env['omniauth.auth']["uid"]
    puts "session: #{session[:uid]}"
    redirect '/'
  end


  get '/' do
    erb :application
  end

  get '/search' do
    key = params[:key]
    note = Note.find_by_key(key)
    if (note.nil?)
      return status(404)
    else
      content_type('application/json')
      return {:key => note.key, :value => note.value, :id => note.id}.to_json
    end
  end

  post '/new' do
    note = Note.new
    note.key = params[:key]
    note.value = params[:value]
    note.user = 'nico'
    note.save
  end

  post '/:id' do
    # update the specified note
  end

end
