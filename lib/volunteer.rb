class Volunteer
  attr_reader(:id, :project_id, :name)
  def initialize(attributes)
    @name = attributes[:name]
    @project_id = attributes[:project_id]
    @id = attributes[:id]
  end

  def save
    result = DB.exec("INSERT INTO volunteers (name, project_id) VALUES ('#{@name}', #{@project_id}) RETURNING id;")
    @id = result[0]["id"].to_i
  end

  def ==(another_volunteer)
    self.name().==(another_volunteer.name())
  end

  def self.all
    returned_volunteers = DB.exec("SELECT * FROM volunteers;")
    volunteers = []
    returned_volunteers.each() do |volunteer|
      name = volunteer["name"]
      project_id = volunteer["project_id"]
      volunteers.push(Volunteer.new({:name => name, :project_id => project_id}))
    end
    volunteers
  end

  def self.find(id)
    returned_volunteers = DB.exec("SELECT * FROM volunteers WHERE id = #{id};")
    volunteers = []
    returned_volunteers.each() do |volunteer|
      name = volunteer["name"]
      project_id = volunteer["project_id"]
      id = volunteer["id"]
      volunteers.push(Volunteer.new({:name => name, :project_id => project_id, :id => id}))
    end
    volunteers[0]
  end

end
