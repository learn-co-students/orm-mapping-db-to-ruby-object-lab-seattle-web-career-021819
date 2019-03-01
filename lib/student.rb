class Student
  attr_accessor :id, :name, :grade

  @@all = []

  def self.new_from_db(row)
    new_student = Student.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    return new_student
  end

  def self.all
    DB[:conn].execute("SELECT * FROM students").map { |row| Student.new_from_db(row) }
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE students.name = \"#{name}\""
    Student.new_from_db(DB[:conn].execute(sql)[0])
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

  def self.all_students_in_grade_9
    DB[:conn].execute("SELECT * FROM students WHERE grade = 9").map { |row| Student.new_from_db(row) }
  end

  def self.students_below_12th_grade
    DB[:conn].execute("SELECT * FROM students WHERE grade < 12").map { |row| Student.new_from_db(row) }
  end

  def self.first_X_students_in_grade_10(num)
    DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT #{num}").map { |row| Student.new_from_db(row) }
  end

  def self.first_student_in_grade_10
    DB[:conn].execute("SELECT * FROM students WHERE grade = 10").map { |row| Student.new_from_db(row) }[0]
  end

  def self.all_students_in_grade_X(num)
    DB[:conn].execute("SELECT * FROM students WHERE grade = #{num}").map { |row| Student.new_from_db(row) }
  end

end
