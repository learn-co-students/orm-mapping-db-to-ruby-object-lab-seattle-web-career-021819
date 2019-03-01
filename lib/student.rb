class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object (instance), with corresponding attribute values, given a row from the database
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student # return the newly created instance
  end

  def self.all
    # retrieve all the rows from the "Students" database
    sql = <<~SQL
      SELECT *
      FROM students
    SQL

    # remember each row should be a new instance of the Student class
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    sql = <<~SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL

    # return a new instance of the Student class
    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end

  def self.all_students_in_grade_9
    # find all students in the database given grade 9
    sql = <<~SQL
      SELECT *
      FROM students
      WHERE grade = 9
    SQL

    # return an array of all the students in grade 9 of the Student class
    rows = DB[:conn].execute(sql)
    rows.map do |row|
      self.new_from_db(row) # method inflates the row into student obj
    end
  end

  def self.students_below_12th_grade
    sql = <<~SQL
      SELECT *
      FROM students
      WHERE grade < 12
    SQL

    rows = DB[:conn].execute(sql)
    rows.map do |row|
      self.new_from_db(row)
    end
  end

  def self.first_X_students_in_grade_10(number)
    sql = <<~SQL
      SELECT *
      FROM students
      WHERE grade = 10
      ORDER BY students.name
      LIMIT ?
    SQL

    rows = DB[:conn].execute(sql, number)
    rows.map do |row|
      self.new_from_db(row)
    end
  end

  def self.first_student_in_grade_10
    sql = <<~SQL
      SELECT *
      FROM students
      WHERE grade = 10
      ORDER BY students.id
      LIMIT 1
    SQL

    rows = DB[:conn].execute(sql)
    rows.map do |row|
      self.new_from_db(row)
    end.first
    # .first method chained to end to grab 1st element from
    # the returned array, output otherwise would ba an array
  end

  def self.all_students_in_grade_X(grade)
    # find all students in the database given grade X
    sql = <<~SQL
      SELECT *
      FROM students
      WHERE grade = ?
      ORDER BY students.name
    SQL

    # return an array of all the students in grade X of the Student class
    DB[:conn].execute(sql, grade).map do |row|
      self.new_from_db(row)
    end
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
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
