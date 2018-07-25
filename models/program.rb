class Program < ActiveRecord::Base
    has_many :exercise_programs
    has_many :exercises, through: :exercise_programs
    belongs_to :user
 end