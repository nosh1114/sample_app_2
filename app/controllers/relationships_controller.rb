class RelationshipsController < ApplicationController
  before_action :logged_in_user
  def create
    # ここではparameterは、relationに関するものが渡される。
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      # create.turbo_stream.erbファイルをrailsが探してくれる。
      format.turbo_stream
    end
  end

  def destroy
    # ここではparameterは、relationに関するものが渡される。
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user, status: :see_other }
      format.turbo_stream
    end
  end
end
