class RateLimitController < ApplicationController
  before_action :check_access_token, only: [:index]

  # ex) curl -i -XGET 'localhost:3000/rate_limit/index?access_token=token1'
  def index
    render json: {date1: "アイウエオ", data2: "aiueo"}
  end

  private

  def check_access_token
    user = User.find_by(access_token: params[:access_token])
    unless user
      render status: :unauthorized, json: {message: "認証エラーです"}
    end
  end
end
