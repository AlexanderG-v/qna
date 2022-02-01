class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :value, presence: true
  validates :value, numericality: { only_integer: true, greater_than_or_equal_to: -1, less_than_or_equal_to: 1 }
  validates :user, uniqueness: { scope: %i[votable_id votable_type] }
  validates :votable_type, inclusion: %w[Question Answer]
end
