class Project
  attr_reader(:id, :title)
  def initialize(attributes)
    @title = attributes[:title]
    @id = attributes[:id]
  end

  def save
    result = DB.exec("INSERT INTO projects (title) VALUES ('#{@title}') RETURNING id;")
    @id = result[0]["id"].to_i
  end

  def ==(another_project)
    self.title().==(another_project.title())
  end

  def self.all
    returned_projects = DB.exec("SELECT * FROM projects;")
    projects = []
    returned_projects.each() do |project|
      title = project["title"]
      projects.push(Project.new({:title => title}))
    end
    projects
  end

  def self.find(id)
    returned_projects = DB.exec("SELECT * FROM projects WHERE id = #{id};")
    projects = []
    returned_projects.each() do |project|
      title = project["title"]
      projects.push(Project.new({:title => title}))
    end
    projects[0]
  end

  def volunteers
    returned_volunteers = DB.exec("SELECT * FROM volunteers WHERE project_id = #{self.id};")
    project_volunteers = []
    returned_volunteers.each() do |volunteer|
      name = volunteer["name"]
      project_id = volunteer["project_id"].to_i
      project_volunteers.push(Volunteer.new({:name => name, :project_id => project_id}))
    end
    project_volunteers
  end
end
