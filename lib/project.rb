class Project
  attr_reader(:id, :title)
  def initialize(attributes)
    @title = attributes[:title]
    @id = attributes[:id]
  end

  def save
    result = DB.exec("INSERT INTO projects (title) VALUES ('#{@title}') RETURNING id")
    @id = result[0]["id"].to_i
  end

  def ==(another_project)
  self.title().==(another_project.title())
end
end
