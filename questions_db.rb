require 'singleton'
require 'sqlite3'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('school.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end


class Users
  def self.find_by_id(id)
    user = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT * FROM users
      WHERE users.id = ?
    SQL

    Users.new(user.first)
  end

  def self.find_by_name(first, last)
    user = QuestionsDatabase.instance.execute(<<-SQL, first, last)
    SELECT *
    From users
    WHERE user.first_name = first AND user.last_name = last
    SQL

    return nil if user.length < 1

    Users.new(user.first)
  end

  def initialize(options)
    @id = options['id']
    @first_name = options['first_name']
    @last_name = options['last_name']
  end

end
