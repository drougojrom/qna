class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :question_id, :right_answer, :created_at, :updated_at, :attached_files
  has_many :comments
  has_many :links

  belongs_to :user

  def attached_files
    answer = Answer.with_attached_files.find(object.id)
    @files = answer.files.map { |file| [file.filename, rails_blob_path(file)] }.to_h
  end
end
