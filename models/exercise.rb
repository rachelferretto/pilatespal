class Exercise < ActiveRecord::Base
    has_many :comments
    has_many :likes
    has_many :users 
    has_many :program_exercises
    has_many :programs, through: :program_exercises
    belongs_to :user
end