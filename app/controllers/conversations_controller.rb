class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @conversations = Conversation.all
  end

  def create
  if Conversation.between(params[:sender_id], params[:recipient_id]).present?
    @conversation = Conversation.between(params[:sender_id], params[:recipient_id]).first
  else
    @conversation = Conversation.create!(conversation_params)
  end
  redirect_to conversation_messages_path(@conversation)
  end

  def mail_box
    @mymails = Conversation.where(sender_id: current_user).or(Conversation.where(recipient_id: current_user))
    @mail = Message.all
  end


  private

  def conversation_params
    params.permit(:sender_id, :recipient_id)
  end
end
