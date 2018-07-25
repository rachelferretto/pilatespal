class Exercise < ActiveRecord::Base
    has_many :comments
    has_many :likes
    has_many :users 
    has_many :exercise_programs
    has_many :programs, through: :exercise_programs
    belongs_to :user
end