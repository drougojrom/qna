class QuestionSerializer < ActiveModel::Serializer

  include Rails.application.routes.url_helpers

  attributes :id, :title, :body, :created_at, :updated_at, :short_title, :attached_files
  has_many :answers
  has_many :comments

  belongs_to :user

  def short_title
    object.title.truncate(7)
  end

  def attached_files
    question = Question.with_attached_files.find(object.id)
    @files = question.files.map { |file| [file.filename, rails_blob_path(file)] }.to_h
  end
end
