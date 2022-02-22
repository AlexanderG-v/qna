class User < ApplicationRecord
  ROLES = %i[admin].freeze
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: %i[github vkontakte]

  has_many :questions, class_name: 'Question', foreign_key: :author_id, dependent: :destroy
  has_many :answers, class_name: 'Answer', foreign_key: :author_id, dependent: :destroy
  has_many :rewards, dependent: :nullify
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  def self.find_for_oauth(auth)
    FindForOauthService.new(auth).call
  end

  def create_authorizations(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def author?(resource)
    id == resource.author_id
  end

  def voted?(obj)
    votes.where(votable: obj).present?
  end

  def subscribed?(question)
    subscriptions.find_by(question_id: question.id)
  end
end
