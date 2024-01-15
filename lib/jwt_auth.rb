require "jwt"

class JwtAuth
  class << self
    def issue payload
      payload.merge!({timestamp: Time.zone.now})
      JWT.encode payload, secret, algorithm
    end

    def decode token
      JWT.decode(token, secret, true, {algorithm:}).first
    rescue JWT::DecodeError
      nil
    end

    def algorithm
      Figaro.env.jwt_algorithm
    end

    def secret
      Figaro.env.jwt_secret
    end
  end
end
