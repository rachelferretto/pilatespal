class User < ActiveRecord::Base
    has_secure_password
    validates :email, 
        :format => {:with => /@/, :message => "Please enter a valid Email address"},
        :presence => {:message => "Enter your email address" },
        :uniqueness => {:message => "Email already exists, please sign in"}
    validates :password, confirmation: true, length: { minimum: 8}
end