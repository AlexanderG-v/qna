class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.role == 'admin' ? admin_ability : user_ability
    else
      quest_ability
    end
  end

  def quest_ability
    can :read, :all
    can :email, User
    can :set_email, User
  end

  def admin_ability
    can :manage, :all
  end

  def user_ability
    quest_ability
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], { author_id: user.id }
    can :destroy, [Question, Answer], { author_id: user.id }
    can :destroy, ActiveStorage::Attachment, record: { author_id: user.id }
    can :destroy, Link, linkable: { author_id: user.id }
    can :best_answer, Answer, question: { author_id: user.id }
    can :show_rewards, User, { author_id: user.id }
    can :show_rewards, Reward, question: { author_id: user.id }
  end
end
