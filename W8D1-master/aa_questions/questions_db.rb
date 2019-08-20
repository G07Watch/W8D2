require 'sqlite3'
require 'singleton'

class QuestionsDB < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class User

  attr_reader :id, :lname, :fname

  def self.all
    data = QuestionsDB.instance.execute("SELECT * FROM users")
    data.map { |datum| User.new(datum) }
  end

  def self.find_by_id(id)
    data = QuestionsDB.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?;
    SQL
    User.new(data[0])
  end

  def self.find_by_name(fname, lname)
    data = QuestionsDB.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND
        lname = ?;
    SQL
    User.new(data[0])
  end

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname= options['lname']
  end

  def authored_questions
    Question.find_by_author_id(self.id)
  end

  def authored_replies
    Reply.find_by_user_id(self.id)
  end
end

class Question

  attr_accessor :id, :title, :body, :user_id

  def self.all
    data = QuestionsDB.instance.execute("SELECT * FROM questions")
    data.map { |datum| Question.new(datum) }
  end

  def self.find_by_id(id)
    data = QuestionsDB.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?;
    SQL
    Question.new(data[0])
  end

  def self.find_by_author_id(user_id)
    data = QuestionsDB.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        questions
      WHERE
        user_id = ?;
    SQL
    Question.new(data[0])
  end

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body= options['body']
    @user_id = options['user_id']
  end

  def author
    User.find_by_id(self.user_id)
  end

   def replies
    Reply.find_by_question_id(self.id)
  end
end

class QuestionFollows
    attr_accessor :id, :user_id, :question_id

    def self.all
        data = QuestionsDB.instance.execute("SELECT * FROM question_follows")
        data.map { |datum| QuestionFollows.new(datum) }
    end

  def self.find_by_id(id)
    data = QuestionsDB.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = ?;
    SQL
    QuestionFollows.new(data[0])
  end

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

  
end

class Reply
    attr_accessor :id, :user_id, :question_id, :body, :parent_reply


    def self.all
        data = QuestionsDB.instance.execute("SELECT * FROM replies")
        data.map { |datum| Reply.new(datum) }
    end
    


  def self.find_by_id(id)
    data = QuestionsDB.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?;
    SQL
    Reply.new(data[0])
  end

  def self.find_by_question_id(question_id)
    data = QuestionsDB.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?;
    SQL
    Question.new(data[0])
  end

  def self.find_by_user_id(user_id)
    data = QuestionsDB.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?;
    SQL
    Question.new(data[0])
  end

  def initialize(options)
    @id = options['id']
    @body = options['body']
    @parent_reply = options['parent_reply']
    @user_id  = options['user_id']
    @question_id = options['question_id']
  end

  def author
    User.find_by_id(self.user_id)
  end

  def question
    Question.find_by_id(self.question_id)
  end

  def parent_reply
    Reply.find_by_id(self.parent_reply)
  end

  def child_replies
    data = QuestionsDB.instance.execute(<<-SQL, self.id)
            SELECT
                *
            FROM
                replies
            WHERE
                replies.parent_reply = ?
            SQL
    data.map { |datum| Reply.new(datum) }
  end

end

class QuestionLikes
    attr_accessor :id, :user_id, :question_id


    def self.all
        data = QuestionsDB.instance.execute("SELECT * FROM question_likes")
        data.map { |datum| QuestionLikes.new(datum) }
    end

  def self.find_by_id(id)
    data = QuestionsDB.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        id = ?;
    SQL
    QuestionLikes.new(data[0])
  end

 def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

end