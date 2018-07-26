require 'active_record'

options = {
    adapter: 'postgresql',
    database: 'pilatespal'
}

ActiveRecord::Base.establish_connection( ENV['DATABASE_URL'] || options)