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
  @project_id = params.fetch('id')
  project_volunteers = Project.new({:title => nil, :id => params.fetch('id').to_i})
  @volunteers_project = project_volunteers.volunteers
  erb(:projects)
end

get('/projects/:id/edit') do
  @project = Project.find(params.fetch("id"))
  erb(:edit)
end

post('/projects/:id/edit') do
  @project = Project.find(params.fetch("id"))
  new_title = params.fetch('title')
  @project.update(:title => new_title, :id => @project.id)

  project_volunteers = Project.new({:title => nil, :id => params.fetch('id').to_i})
  @volunteers_project = project_volunteers.volunteers
  erb(:projects)
end

delete('/projects/:id/edit') do
  @project = Project.find(params.fetch("id"))
  @project.delete
  @delete = true
  erb(:edit)
end

get('/projects/:id/edit/volunteers/:volunteer_id') do
  @volunteer = Volunteer.find(params.fetch("volunteer_id"))
  @project = Project.find(params.fetch("id"))
  erb(:volunteer_edit)
end

post('/projects/:id/edit/volunteers') do
  name = params.fetch('name')
  project_id = params.fetch('id')
  volunteer = Volunteer.new({:name => name, :project_id => project_id})
  volunteer.save
  @project = Project.find(params.fetch("id"))

  project_volunteers = Project.new({:title => nil, :id => params.fetch('id').to_i})
  @volunteers_project = project_volunteers.volunteers
  erb(:projects)
end

post('/projects/edit/:id/volunteers/update/:volunteer_id') do
  @volunteer = Volunteer.find(params.fetch('volunteer_id'))
  @volunteer.update(:name => params.fetch('name'), :id => @volunteer.id.to_i)

  @project = Project.find(params.fetch("id"))
  project_volunteers = Project.new({:title => nil, :id => params.fetch('id').to_i})
  @volunteers_project = project_volunteers.volunteers

  erb(:projects)
end
