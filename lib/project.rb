class Project
  attr_reader(:id, :title)
  def initialize(attributes)
    @title = attributes[:title]
    @id = attributes[:id]
  end
end
