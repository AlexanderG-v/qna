class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github]

  has_many :questions, class_name: 'Question', foreign_key: :author_id, dependent: :destroy
  has_many :answers, class_name: 'Answer', foreign_key: :author_id, dependent: :destroy
  has_many :rewards, dependent: :nullify
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    user = User.where(email: email).first
    if user
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
    end
    user.create_authorizantions(auth)
    user
  end

  def create_authorizantions(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def author?(resource)
    id == resource.author_id
  end

  def voted?(obj)
    votes.where(votable: obj).present?
  end
end
