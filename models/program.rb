class Program < ActiveRecord::Base
    has_many :program_exercises
    has_many :exercises, through: :program_exercises
    belongs_to :user
 end