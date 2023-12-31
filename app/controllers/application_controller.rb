class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :error_response

  def error_response(error)
    render json: ErrorSerializer.new(error).serialize_json, status: 404
  end
end
