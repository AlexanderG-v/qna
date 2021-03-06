class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true, touch: true
  belongs_to :user

  validates :body, presence: true

  ThinkingSphinx::Callbacks.append(
    self, behaviours: [:sql]
  )
end
