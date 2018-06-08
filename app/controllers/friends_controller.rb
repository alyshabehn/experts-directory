class FriendsController < ApplicationController
  def update
    @member = Member.find(params[:member_id])
    @friend = Member.find(params[:id])
    Friendship.create(member: @member, friend: @friend)
    Friendship.create(member: @friend, friend: @member)


    redirect_to member_path(@member)

  end
end
