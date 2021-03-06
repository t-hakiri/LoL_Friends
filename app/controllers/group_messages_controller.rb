class GroupMessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: :index

  def index
    @group_messages = @group.group_messages.order(:created_at)
    gon.current_user = current_user
    gon.group = @group
    gon.avater = current_user.avater

    if @group.join_group_users.find_by(id: current_user)
      if @group_messages.length > 10

        @over_ten = true
        # @group_messages = @group_message.where(id: @group_messages.last(10).map{|msg| msg.id})
        @group_messages = @group_messages.where(id: @group_messages[-10..-1].pluck(:id))
      end

      if params[:m]
        @over_ten = false
        @group_messages = @group.group_messages
      end

      @group_messages = @group_messages.order(:created_at)
      @group_message = @group.group_messages.build
    else
      flash[:danger] = 'あなたはこのグループに参加していません'
      redirect_to group_path(@group)
    end
  end

  def destroy
    @group_message = GroupMessage.find(params[:id])
    group = @group_message.group
    @group_message.destroy
    flash[:success] = '投稿を削除しました'
    redirect_to group_group_messages_path(group)
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def group_message_params
    params.require(:group_message).permit(:content, :user_id, :image)
  end
end
