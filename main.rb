     
require 'sinatra'
require 'pg'
require 'pry'
require 'sinatra/reloader'


require_relative 'db_config'
require_relative 'models/user'
require_relative 'models/exercise'
require_relative 'models/like'
require_relative 'models/comment'

enable :sessions

helpers do 
  def current_user 
    User.find_by(id: session[:user_id])
  end

  def logged_in?
    if current_user
      true
    else
      false
    end

  end

end

get '/' do
  @exercises = Exercise.all
  erb :index
end


get '/exercises/new' do
  erb :new
end

post '/exercises' do
  exercise = Exercise.new
  exercise.name = params[:name]
  exercise.image_url = params[:image_url]
  exercise.level = params[:level]
  exercise.reps = params[:reps]
  exercise.muscle_groups = params[:muscle_groups]
  exercise.description = params[:description]
  exercise.save
  redirect '/'
end




get '/exercises/:id' do
  @exercise = Exercise.find(params[:id])
  @comments = @exercise.comments
  erb :exercise_details
end

delete '/exercises/:id' do
  redirect '/login' unless logged_in?
  exercise = Exercise.find(params[:id])
  exercise.destroy
  redirect '/'
end

get '/exercises/:id/edit' do
  @exercise = Exercise.find(params[:id])
  erb :edit
end

put '/exercises/:id' do
  exercise = Exercise.find(params[:id])
  exercise.name = params[:name]
  exercise.image_url = params[:image_url]
  exercise.level = params[:level]
  exercise.reps = params[:reps]
  exercise.muscle_groups = params[:muscle_groups]
  exercise.description = params[:description]
  exercise.save
  redirect "/exercises/#{params[:id]}"
end



post '/comments' do
  redirect '/login' unless logged_in?
  comment = Comment.new
  comment.content = params[:content]
  comment.exercise_id = params[:exercise_id]
  comment.comment_time = Time.now.strftime("%H:%M %-d %b %y")
  comment.save
  redirect "/exercises/#{params[:exercise_id]}"
end

delete '/comments/:id' do
  comment = Comment.find(params[:id])
  comment.destroy
  redirect "/"
end

post '/likes' do
  like = Like.new
  like.dish_id = params[:dish_id]
  like.user_id = current_user.id
  like.save

  redirect "/dishes/#{params[:dish_id]}"
end


get '/login' do 
  erb :login
end

post '/session' do
  user = User.find_by(email: params[:email])
  if user && user.authenticate(params[:password])
   session[:user_id] = user.id
    redirect '/'
  else 
    erb :login
  end
end

delete '/session' do
  session[:user_id] = nil
  redirect '/login'
end



