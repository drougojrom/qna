class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :right_answer, :created_at, :updated_at, :attached_files
  has_many :comments
  has_many :links

  belongs_to :user

  def attached_files
    @files = Answer.with_attached_files.find(object.id).files.each do |file|
      return { file.filename => rails_blob_path(file) }
    end
  end
end
