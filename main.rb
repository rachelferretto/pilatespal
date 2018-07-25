     
require 'sinatra'
require 'pg'
require 'pry'
require 'sinatra/reloader'


require_relative 'db_config'
require_relative 'models/user'
require_relative 'models/exercise'
require_relative 'models/like'
require_relative 'models/comment'
require_relative 'models/program'
require_relative 'models/program_exercise'

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

get '/about' do
  erb :about
end


post '/search' do
  @exercises = Exercise.all
  @search = params[:search]
  erb :search
end


post '/my_program' do
  @myprogram = ProgramExercise.new(
   program_id: Program.find_by(user_id: current_user.id).id, 
   exercise_id: params[:exercise_id]
  )
  @myprogram.save
  redirect "/my_program"  
end

get '/my_program' do
  @myprogram = Program.find_by(user_id: current_user.id)
  erb :my_program
end

delete '/my_program/:id' do
  myprogram = Program.where(user_id: current_user.id).first
  ProgramExercise.where(program_id: myprogram).destroy_all
  myprogram.destroy
  program = Program.new
  program.user_id = current_user.id
  program.save
  redirect '/my_program'
end


get '/beginner_program' do
  @exercises = Exercise.all
  erb :beginner_program
end

get '/intermediate_program' do
  @exercises = Exercise.all
  erb :intermediate_program
end

get '/advanced_program' do
  @exercises = Exercise.all
  erb :advanced_program
end


get '/exercises/new' do
  redirect '/login' unless logged_in?
  erb :new
end

post '/exercises' do
  redirect '/login' unless logged_in?
  exercise = Exercise.new
  exercise.name = params[:name]
  exercise.image_url = params[:image_url]
  exercise.level = params[:level]
  exercise.reps = params[:reps]
  exercise.muscle_groups = params[:muscle_groups]
  exercise.description = params[:description]
  exercise.user_id = current_user.id
  exercise.save
  redirect '/'
end


get '/exercises/:id' do
  redirect '/login' unless logged_in?
  @exercise = Exercise.find(params[:id])
  @comments = @exercise.comments
  @likes = @exercise.likes
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

get '/signup' do
  erb :signup
end

post '/signup' do
  user = User.new
  user.email = params[:email]
  user.password = params[:password]
  user.save
  program = Program.new(
    user_id: user.id
  )
  program.save
  redirect '/login'
end


post '/comments' do
  redirect '/login' unless logged_in?
  comment = Comment.new
  comment.content = params[:content]
  comment.exercise_id = params[:exercise_id]
  comment.comment_time = Time.now.strftime("%H:%M %-d %b %y")
  comment.user_id = current_user.id
  comment.save
  redirect "/exercises/#{params[:exercise_id]}"
end

delete '/comments/:id' do
  comment = Comment.find(params[:id])
  comment.destroy
  redirect "/exercises/#{params[:exercise_id]}"
end

post '/likes' do
  redirect '/login' unless logged_in?
  like = Like.new
  like.exercise_id = params[:exercise_id]
  like.user_id = current_user.id
  like.save

  redirect "/exercises/#{params[:exercise_id]}"
end


get '/login' do 
  if logged_in?
    redirect '/'
  end
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







