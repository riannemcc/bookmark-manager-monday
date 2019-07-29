require 'sinatra/base'
require './lib/bookmark'
require './lib/comment'
require_relative './database_connection_setup.rb'
require 'sinatra/flash'
require 'uri'
require './lib/tag'
require './lib/user'
require './lib/bookmark_tag'

class BookMarkManager < Sinatra::Base
  enable :sessions, :method_override
  register Sinatra::Flash

  get '/' do
    @user = User.find(id: session[:user_id])
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

  get '/bookmarks/:id/comments/new' do
    @bookmark_id = params[:id]
    erb :'comments/new'
  end

  post '/bookmarks/:id/comments' do
    Comment.create(text: params[:comment], bookmark_id: params[:id])
    redirect '/'
  end

  delete '/comments/:id' do
    Comment.delete(id: params[:id])
    redirect '/'
  end

  get '/bookmarks/:id/tags/new' do
    @bookmark_id = params[:id]
    erb :'/tags/new'
  end

  post '/bookmarks/:id/tags' do
    tag = Tag.create(content: params[:tag])
    BookmarkTag.create(bookmark_id: params[:id], tag_id: tag.id)
    redirect '/'
  end

  get '/tags/:id/bookmarks' do
    @tag = Tag.find(id: params['id'])
    erb :'tags/index'
  end

  get '/users/new' do
    erb :'users/new'
  end

  post '/users' do
    user = User.create(email: params[:email], password: params[:password])
    session[:user_id] = user.id
    redirect '/'
  end

  get '/sessions/new' do
    erb :"sessions/new"
  end

  post '/sessions' do
    user = User.authenticate(email: params[:email], password: params[:password])
    if user
      session[:user_id] = user.id
      redirect('/')
    else
      flash[:notice] = 'Please check your email or password.'
      redirect('/sessions/new')
    end
  end

  run! if app_file == $0
end
