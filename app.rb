require 'sinatra'
require 'sinatra/reloader'
also_reload 'lib/**/*.rb'
require './lib/project'
require './lib/volunteer'
require 'pg'
require 'rspec'
require 'pry'

DB = PG.connect(:dbname => 'volunteer_tracker_test')

get('/') do
  @projects = Project.all
  @volunteers = Volunteer.all
  erb(:index)
end

post('/') do
  title = params.fetch('title')
  project = Project.new({:title => title})
  project.save
  @projects = Project.all
  erb(:index)
end

get('/projects/:id') do
  @project = Project.find(params.fetch('id'))
  erb(:projects)
end

get('/edit/:id') do
  @project = Project.find(params.fetch("id"))
  erb(:edit)
end

post('/edit/:id') do
  @project = Project.find(params.fetch("id"))
  new_title = params.fetch('title')
  @project.update(:title => new_title, :id => @project.id)
  erb(:projects)
end
