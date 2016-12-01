require 'sinatra'
require 'yaml/store'
include FileUtils::Verbose

get '/' do
  @title = 'Welcome to the voting App!'
  erb :index
end

get '/student' do
  erb :student
end

get '/upload' do
  erb :upload
end

post '/upload' do
  tempfile = params[:file][:tempfile]
  filename = params[:file][:filename]
  cp(tempfile.path, "public/uploads/#{filename}")
  erb :uploadSucc
end

Choices = {
    'HAM' => 'Hamburger',
    'PIZ' => 'Pizza',
    'CUR' => 'Curry',
    'NOO' => 'Noodles',
}


post '/cast' do
  @title = 'Thanks for casting your vote!'
  @vote  = params['vote']
  @store = YAML::Store.new 'votes.yml'
  @store.transaction do
    @store['votes'] ||= {}
    @store['votes'][@vote] ||= 0
    @store['votes'][@vote] += 1
  end
  erb :cast
end

get '/results' do
  @title = 'Results so far:'
  @store = YAML::Store.new 'votes.yml'
  @votes = @store.transaction { @store['votes'] }
  erb :results
end