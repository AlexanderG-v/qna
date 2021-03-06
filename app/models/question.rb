class Question < ApplicationRecord
  include Votable

  belongs_to :author, class_name: 'User'
  belongs_to :best_answer, class_name: 'Answer', optional: true
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :comments, dependent: :destroy, as: :commentable
  has_many :subscriptions, dependent: :destroy
  has_one :reward, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

  ThinkingSphinx::Callbacks.append(
    self, behaviours: [:sql]
  )

  # after_create :subscribe_author

  def set_best_answer(answer)
    transaction do
      update!(best_answer: answer)
      reward&.update!(user: answer.author)
    end
  end

  private

  def subscribe_author
    subscriptions.create!(author: user)
  end
end
