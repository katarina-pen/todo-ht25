require 'sinatra'
require 'sqlite3'
require 'slim'
require 'sinatra/reloader'



# yay

# Routen /
get '/' do
    slim(:index)
end


