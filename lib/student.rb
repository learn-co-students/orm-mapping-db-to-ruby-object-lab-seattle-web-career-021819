class Student
  attr_accessor :id, :name, :grade

  def initialize(id: nil, name: name, grade: grade)
    @id = id
    @name = name
    @grade = grade
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    self.new(id: row[0], name: row[1], grade: row[2])
  end

  # Helper to create new students from query
  def self.create_students_from_query(sql, *args)
    results = DB[:conn].execute(sql, *args)
    results.map do |row|
      self.new_from_db(row)
    end
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = "SELECT * FROM students"
    self.create_students_from_query(sql)
  end

  # Returns an array of students with grade 9
  def self.all_students_in_grade_9
    sql = <<~SQL
      SELECT * FROM students
      WHERE grade = 9
    SQL

    self.create_students_from_query(sql)
  end

  # Returns an array of students with grade below 12
  def self.students_below_12th_grade
    sql = <<~SQL
      SELECT * FROM students
      WHERE grade < 12
    SQL

    self.create_students_from_query(sql)
  end

  # Returns an array of the first given number of students with grade 10
  def self.first_X_students_in_grade_10(x)
    sql = <<~SQL
      SELECT * FROM students
      WHERE grade = 10
      LIMIT ?
    SQL

    self.create_students_from_query(sql, x)
  end

  # Returns the first student with grade 10
  def self.first_student_in_grade_10
    self.first_X_students_in_grade_10(1)[0]
  end

  # Returns an array of all students with grade of given value
  def self.all_students_in_grade_X(x)
    sql = <<~SQL
      SELECT * FROM students
      WHERE grade = ?
    SQL

    self.create_students_from_query(sql, x)
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<~SQL
      SELECT * FROM students
      where name = ?
    SQL

    self.new_from_db(DB[:conn].execute(sql, name)[0])
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
