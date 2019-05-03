require 'rails_helper'

RSpec.describe Question, type: :model do

  it_should_behave_like 'votable'

  describe 'associations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:links).dependent(:destroy) }
    it { should belong_to :user }
    it { should accept_nested_attributes_for :links }
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

  it 'has many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'reputation' do
    let(:question) { build(:question) }

    it 'calls ReputationJob' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end

  describe 'subscription' do
    let(:question) { create :question, user: user }

    it 'add subscription to the question' do
      expect { question.add_subscription(user) }.to change(Subscription, :count).by 1
    end

    it 'removes an existing subscription' do
      question.add_subscription(question.user)
      expect { question.remove_subscription(user) }.to change(Subscription, :count).by -1
    end
  end
end
