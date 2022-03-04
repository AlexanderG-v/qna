class Answer < ApplicationRecord
  include Votable

  belongs_to :question, touch: true
  belongs_to :author, class_name: 'User'
  has_many :links, dependent: :destroy, as: :linkable
  has_many :comments, dependent: :destroy, as: :commentable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  after_create :send_notifications

  ThinkingSphinx::Callbacks.append(
    self, behaviours: [:sql]
  )

  private

  def send_notifications
    NotificationJob.perform_later(self)
  end
end
