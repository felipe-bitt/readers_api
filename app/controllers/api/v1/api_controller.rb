class Api::V1::ApiController < ApplicationController

  attr_accessor :current_user

  def not_found
    render json: { error: 'not_found' }
  end

  def authorize_request
    token = request.headers['Authorization']
    begin
      @decoded_token = JsonWebToken.decode(token)
      @current_user = User.find_by_id(@decoded_token[:user_id])
      render json: { errors: 'Usuário não autorizado!' }, status: :unauthorized unless @current_user
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end