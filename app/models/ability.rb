# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : users_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def users_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer, Comment], user_id: user.id
    can :destroy, [Question, Answer, Comment], user_id: user.id
    can :vote_for, [Question, Answer, Comment]
    can :vote_against, [Question, Answer, Comment]
    can :vote_revoke, [Question, Answer, Comment]
    can :manage, ActiveStorage::Attachment
    can :manage, User
    answers_abilities
    rewards_abilities
    links_abilities
  end

  private 

  def answers_abilities
    can :right_answer, Answer, user_id: user.id
    can :not_right_answer, Answer, user_id: user.id
  end

  def rewards_abilities
    can :index, Reward
  end

  def links_abilities
    can :update, Link
    can :destroy, Link
  end
end
