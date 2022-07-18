class RateLimitController < ApplicationController
  # リクエスト制限をかける一定時間
  # アプリケーション共通の定数など別の方法で管理すべきだがサンプルなので
  INTERBAL_SECONDS = 60 * 10

  # 認証のbefore_actionは、通常はBASEのコントローラなどにまとめるべき
  before_action :set_current_user, only: [:index]
  before_action :check_access_token, only: [:index]
  before_action :check_rate_limit, only: [:index]

  # ex) curl -i -XGET 'localhost:3000/rate_limit/index?access_token=token1'
  def index
    render json: {date1: "アイウエオ", data2: "aiueo"}
  end

  private

  # ユーザの取得
  # @return [void]
  def set_current_user
    @current_user = User.find_by(access_token: params[:access_token])
  end

  # アクセストークンの確認
  # @return [void]
  def check_access_token
    unless @current_user
      render status: :unauthorized, json: {message: "認証エラーです"}
      return
    end
  end

  # APIリクエスト数制限回数の確認
  # @note リクエスト回数の保持は、Key-Valueストアを利用するが、RDBで仮実装
  # @return [void]
  def check_rate_limit
    counter = RequestCounter.find_by(access_token: params[:access_token])
    unless counter
      render status: :unauthorized, json: {message: "認証エラーです"}
      return
    end

    counter.count += 1

    # 制限オーバーの場合のレスポンス
    if @current_user.over_rate_limit?(counter)
      response.headers["Retry-After"] = 3600 # TODO: リクエストできるまでの秒数
      render status: :too_many_requests, json: {message: "一定時間内のリクエスト数をオーバーしました"}
      return
    end

    if counter.start_at + INTERBAL_SECONDS < Time.now
      counter.start_at = Time.now
      counter.count = 1
    end

    counter.save

    response.headers["X-Rate-Limit-Limit"] = @current_user.api_rate_limit
    response.headers["X-Rate-Limit-Remaining"] = @current_user.api_rate_limit - counter.count
    response.headers["X-Rate-Limit-Reset"] = 3600 # TODO: リクエストできるまでの秒数
  end
end
