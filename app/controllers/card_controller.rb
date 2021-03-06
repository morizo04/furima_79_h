class CardController < ApplicationController
  require "payjp"
  before_action :authenticate_user!
  before_action :set_card
  before_action :set_category

  def new
    @card = Card.where(user_id: current_user.id)
    redirect_to action: "show" if @card.exists?
  end

  def pay #payjpとCardのデータベース作成を実施します。
    Payjp.api_key = Rails.application.credentials[:payjp][:payjp_access_key]
    if params['payjp-token'].blank?
      redirect_to action: "new"
    else
      @customer = Payjp::Customer.create(
      # description: '登録テスト', #なくてもOK
      # email: current_user.email, #なくてもOK
      card: params['payjp-token'],
      metadata: {user_id: current_user.id}
      ) #念の為metadataにuser_idを入れましたがなくてもOK
      @card = Card.new(user_id: current_user.id, customer_id: @customer.id, card_id: @customer.default_card)
      if @card.save
        redirect_to action: "show"
      else
        redirect_to action: "pay"
      end
    end
  end

  def delete #PayjpとCardデータベースを削除します
    @card = Card.where(user_id: current_user.id).first
    if @card.present?
      Payjp.api_key = Rails.application.credentials[:payjp][:payjp_access_key]
      @customer = Payjp::Customer.retrieve(@card.customer_id)
      @customer.delete
      @card.delete
    else
      flash[:alert] = 'カード情報を削除しました'
      redirect_to action: "new"
    end
  end

  def show #Cardのデータpayjpに送り情報を取り出します
    @card = Card.where(user_id: current_user.id).first
    if @card.blank?
      flash.now[:alert] = 'カードを登録してください'
      redirect_to action: "new"
    else
      Payjp.api_key = Rails.application.credentials[:payjp][:payjp_access_key]
      @customer = Payjp::Customer.retrieve(@card.customer_id)
      @default_card_information = @customer.cards.retrieve(@card.card_id)
    end
  end
  private

  def set_card
    @card = Card.where(user_id: current_user.id).first if Card.where(user_id: current_user.id).present?
  end
  def set_category
    @parents = Category.where(ancestry: nil)
  end
end