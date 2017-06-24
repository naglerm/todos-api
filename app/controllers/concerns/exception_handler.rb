module ExceptionHandler
  extend ActiveSupport::Concern#provides 'included' method

  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end
  class ExpiredSignature < StandardError; end

  included do
  rescue_from ActiveRecord::RecordInvalid, with: :four_twenty_two
  rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
  rescue_from ExceptionHandler::MissingToken, with: :four_twenty_two
  rescue_from ExceptionHandler::InvalidToken, with: :four_twenty_two
    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({message: e.message}, :not_found)
    end
    rescue_from ExceptionHandler::ExpiredSignature do |e|
      json_response({message: e.message}, 'Signature has expired')
    end
  end


  private

  #json response unprocessable_entity
  def four_twenty_two(e)
    json_response({message: e.message}, :unprocessable_entity)
  end

  #json response message, unauthorized_request
  def unauthorized_request(e)
    json_response({message: e.message}, :unauthorized)
  end
end
