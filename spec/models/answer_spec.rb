require 'rails_helper'

RSpec.describe Answer, type: :model do

  describe 'associations' do
    it { should belong_to :question }
    it { should belong_to :user }
  end

  describe 'validations' do
    it { should validate_presence_of :body }
  end

  let(:user) { create :user }
  let(:question_with_right_answers) { create :question_with_right_answers, user: user}
  let(:answer) { create :answer, user: user }
  let(:right_answer) { create :answer, question: answer.question, user: user, right_answer: true }

  describe 'right_answer' do
    before do
      question_with_right_answers.answers.first.make_right_answer(question_with_right_answers.user, true)
      question_with_right_answers.reload
      question_with_right_answers.answers.reload
    end

    it 'validates that right answer changes' do
      expect(right_answer.right_answer).to eq true
      expect(answer.right_answer).to eq false
      answer.make_right_answer(answer.question.user, true)
      right_answer.reload
      expect(answer.right_answer).to eq true
      expect(right_answer.right_answer).to eq false
    end

    it 'is only one right answer' do
      expect(question_with_right_answers.answers.where(right_answer: true).count).to eq 1
    end

    it 'right answer of question with right answer is the first one' do
      expect(question_with_right_answers.answers.first).to eq question_with_right_answers.right_answer
    end

    it 'first answer is the right one' do
      expect(question_with_right_answers.answers.first.right_answer).to eq true
      expect(question_with_right_answers.answers.last.right_answer).to eq false
    end
  end

  describe 'not_right_answer' do
    before { right_answer.make_right_answer(right_answer.question.user, false) }
    it { expect(right_answer.right_answer).to eq false }
    it 'question does not have any right answers' do
      expect(right_answer.question.right_answer).to eq nil
    end
  end
end
