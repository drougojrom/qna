class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  default_scope { order("right_answer DESC").order("created_at DESC") }
  scope :correct_answers, -> { where("right_answer = ?", true) }

  def make_right_answer(user, correct)
    correct ? make_correct(user) : make_not_correct(user)
  end

  private

  def make_correct(user)
    transaction do
      if user.author_of?(self.question)
        self.question.answers.correct_answers.update_all("right_answer = false")
        self.reload.update!(right_answer: true)
      end
    end
  end

  def make_not_correct(user)
    if user.author_of?(self.question)
      self.reload.update(right_answer: false)
    end
  end
end
