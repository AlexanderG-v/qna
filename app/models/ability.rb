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
    can :me, User
    can :create, [Question, Answer, Comment, Subscription]
    can :update, [Question, Answer], { author_id: user.id }
    can :destroy, [Question, Answer], { author_id: user.id }
    can :destroy, [Subscription], { user_id: user.id }
    can :destroy, ActiveStorage::Attachment, record: { author_id: user.id }
    can :destroy, Link, linkable: { author_id: user.id }
    can :best_answer, Answer, question: { author_id: user.id }
    can :show_rewards, User, { author_id: user.id }
    can :show_rewards, Reward, question: { author_id: user.id }

    alias_action :vote_up, :vote_down, to: :vote
    can :vote, [Question, Answer] do |votable|
      !user.author?(votable)
    end

    can :cancel_vote, [Question, Answer] do |votable|
      user.voted?(votable)
    end
  end
end
