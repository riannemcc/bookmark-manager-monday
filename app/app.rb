require 'sinatra'
require './lib/bookmark'
require_relative './database_connection_setup.rb'
require 'sinatra/flash'
require 'uri'

class BookMarkManager < Sinatra::Base
  enable :sessions, :method_override
  register Sinatra::Flash

  get '/' do
    @bookmarks = Bookmark.all
    erb :index
  end

  get '/bookmarks/new' do
    erb :bookmarks_new
  end

  post '/bookmarks_create' do
    flash[:notice] = "You must submit a valid URL." unless
    Bookmark.create(title: params[:title], url: params[:url])
    redirect '/'
  end

  delete '/bookmarks/:id' do
    Bookmark.delete(id: params[:id])
    redirect '/'
  end

  get '/bookmarks/:id/edit' do
    @bookmark = Bookmark.find(id: params[:id])
    erb :bookmarks_edit
  end

  patch '/:id' do
    Bookmark.edit(id: params[:id], title: params[:title], url: params[:url])
    redirect '/'
  end
end
