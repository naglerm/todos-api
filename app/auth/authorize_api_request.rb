class AuthorizeApiRequest
  def initialize(headers = {})
    @headers = headers
  end

  #service point entry, return valid user
  def call
    {
      user: user
    }
  end

  private

  attr_reader :headers

  def user
    #check database for user, memoize user object
    @user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token
    #handle user not found
  rescue ActiveRecord::RecordNotFound => e
    #raise custom error
    raise(
      ExceptionHandler::InvalidToken,
      ("#{Message.invalid_token}, #{e.message}")
      )
  end

  #decode authentication token
  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  def http_auth_header
    if headers['Authorization'].present?
      return headers['Authorization'].split(' ').last
    end
    raise(ExceptionHandler::MissingToken, Message.missing_token)
  end
end
