class Api::V1::SessionsController < ApplicationController
	def create
	end

	def destroy
		user = User.find_by(auth_token: params[:id])
		user.generate_authentication_token!
		user.save
		head 204
	end

	private 

	def sessions_params
		params.require(:session).permit(:email, :password)
	end
end
