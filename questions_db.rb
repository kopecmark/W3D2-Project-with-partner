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

    return nil if user.length < 1
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

  def authored_questions
    Questions.find_by_author_id(@id)
  end

  def authored_replies
    Replies.find_by_user_id(@id)
  end

end


class Questions
  def self.find_by_author_id(author_id)
    author = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT * FROM questions
      WHERE questions.author = ?
    SQL

    return nil if author.length < 1

    result = []
    author.each { |el| result << Questions.new(el) }
    result
  end

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author = options['author']
  end


end
class Replies
  def self.find_by_user_id(user_id)
    user = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT * FROM replies
      WHERE replies.user_id = ?
    SQL

    return nil if user.length < 1
    result = []
    user.each { |el| result << Replies.new(el) }
    result
  end

  def self.find_by_question_id(question_id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT * FROM replies
    WHERE question_ref = ?
    SQL
    return nil if reply.length < 1

    result = []
    reply.each { |el| result << Replies.new(el) }
    result
  end

  def initialize(options)
    @id = options['id']
    @question_ref = options['question_ref']
    @parent_reply = options['parent_reply']
    @user_id = options['user_id']
    @body = options['body']
  end

end

# p Questions.find_by_author_id(2)
# p Replies.find_by_user_id(1)
# p Replies.find_by_question_id(4)

user = Users.find_by_id(1)
# p user.authored_questions
p user.authored_replies
