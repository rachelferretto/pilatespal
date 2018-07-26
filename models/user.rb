class User < ActiveRecord::Base
    has_secure_password
    validates :email, 
        :length => {:minimum => 3, :maximum => 254},
        :uniqueness => {:case_sensitive => false, :message => "Email already exists, please sign in"}
    validates :email, :format => /@/
    validates :password, confirmation: true, length: { minimum: 8}
end