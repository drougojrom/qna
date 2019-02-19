require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'associations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should belong_to :user }
  end

  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end

  let(:user) { create :user }
  let(:question) { create :question, user: user }
  let!(:right_answer) { create :answer, question: question, user: user, right_answer: true }
  let!(:answer) { create :answer, question: question, user: user, right_answer: false }

  it 'right answer on question should be equal to answer' do
    expect(question.right_answer).to eq right_answer
  end

  it 'has one attached file' do
    expect(Question.new.file).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
