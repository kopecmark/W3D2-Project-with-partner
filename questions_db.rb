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

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(@id)
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

  def self.find_by_question_id(question_id)
    question = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT * FROM questions
      WHERE questions.id = ?
    SQL

    return nil if question.length < 1
    Questions.new(question.first)
  end

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author = options['author']
  end

  def author
    Users.find_by_id(@author)
  end

  def replies
    Replies.find_by_question_id(@id)
  end

  def followers
    QuestionFollow.followers_for_question_id(@id)
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

  def self.find_by_id(reply_id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, reply_id)
      SELECT * FROM replies
      WHERE id = ?
    SQL

    return nil if reply.length < 1
    Replies.new(reply.first)
  end

  def initialize(options)
    @id = options['id']
    @question_ref = options['question_ref']
    @parent_reply = options['parent_reply']
    @user_id = options['user_id']
    @body = options['body']
  end

  def author
    Users.find_by_id(@user_id)
  end

  def question
    Questions.find_by_question_id(@question_ref)
  end

  def parent_reply
    Replies.find_by_id(@parent_reply)
  end

  def child_replies
    reply = QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT * FROM replies
      WHERE parent_reply = ?
    SQL

    return nil if reply.length < 1
    Replies.new(reply.first)
  end

end


class QuestionFollow
  def self.followers_for_question_id(question_id)
    users = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT users.* FROM users
      JOIN question_follows
        ON users.id = question_follows.users
      WHERE question_follows.questions = ?
    SQL

    result = []
    users.each { |el| result << Users.new(el) }
    result
  end

  def self.followed_questions_for_user_id(user_id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT questions.* FROM questions
      JOIN question_follows
        ON questions.id = question_follows.questions
      WHERE question_follows.users = ?
    SQL

    result = []
    questions.each { |el| result << Questions.new(el) }
    result
  end
end


# p Questions.find_by_author_id(2)
# p Replies.find_by_user_id(1)
# p Replies.find_by_question_id(4)

# user = Users.find_by_id(1)
# # p user.authored_questions
# p user.authored_replies
# q = Replies.find_by_question_id(4).first
# p q.child_replies

p QuestionFollow.followers_for_question_id(2)
