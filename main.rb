     
require 'sinatra'
require 'pg'
require 'pry'
require 'sinatra/reloader'


require_relative 'db_config'
require_relative 'models/user'
require_relative 'models/exercise'
require_relative 'models/like'
require_relative 'models/comment'



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
  @exercise = Exercise.find( params[:id] )
  @comments = @exercise.comments
  erb :exercise_details
end

delete '/exercises/:id' do
  exercise = Exercise.find( params[:id])
  exercise.destroy
  redirect '/'
end


post '/comments' do
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




