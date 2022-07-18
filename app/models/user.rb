class User < ApplicationRecord
  INTERBAL_SECONDS = 60 * 10

  def over_rate_limit?(counter)
    return false unless counter
    return false if counter.start_at + INTERBAL_SECONDS < Time.now
    
    counter.count > api_rate_limit
  end
end
