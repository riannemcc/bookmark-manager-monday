require 'sinatra'
require './lib/bookmark'

class BookMarkManager < Sinatra::Base

  get '/' do
    @bookmarks = Bookmark.all
    erb :index
  end

  get '/bookmarks/new' do
    erb :bookmarks_new
  end

  post '/bookmarks_create' do
    Bookmark.create(params[:title], params[:url])
    redirect '/'
  end
end
