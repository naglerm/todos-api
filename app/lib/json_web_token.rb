class JsonWebToken
  #secret to encode/decode payload
  HMAC_SECRET = Rails.application.secrets.secret_key_base

  def self.encode(payload, exp = 24.hours.from_now)
    #set expiry to 24 hours after creation
    payload[:exp] = exp.to_i
    #sign token with application secret
    JWT.encode(payload, HMAC_SECRET)
  end

  def self.decode(token)
    #get payload, first index in token array
    body = JWT.decode(token, HMAC_SECRET)[0]
    HashWithIndifferentAccess.new body

    #rescue from exceptions
  rescue JWT::ExpiredSignature, JWT::VerificationError => e
    #raise custom error to be handled by custom handler
    raise(ExceptionHandler::ExpiredSignature, e.message)
  end
end
