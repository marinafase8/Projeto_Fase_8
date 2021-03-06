require 'rails_helper'

RSpec.describe 'Users API', type: :request do
	let!(:user) { create(:user) }
	let(:user_id){ user.id }
	let(:headers) {{ "Accept" => "application/vnd.projetofase8.v1", "Authorization" => user.auth_token }}

	before { host! "localhost:3000/api" }

	describe "GET user/:id" do

		before do
			get "/users/#{user_id}", params: {}, headers: headers
		end

		context "when the user exists" do
			
			it "return the user" do
				expect(json_body["id"]).to eq(user_id)
			end

			it "returns status code 200" do
				expect(response).to have_http_status(200)
			end
		end

		context "when the user does not exists" do
			let(:user_id){ 10000 }

			it "returns status code 404" do
				expect(response).to have_http_status(404)
			end
		end
	end	

	describe "POST user/" do

		before do
			post "/users", params: {user: user_params}, headers: headers

		end

		context "when the request params are valid" do
			let(:user_params){ attributes_for(:user) }

			it "returns status code 201" do 
				expect(response).to have_http_status(201)
			end

			it "returns json data for the created user" do
				expect(json_body["email"]).to eq(user_params[:email])
			end
		end

		context "when the request params are invalid" do
			let(:user_params){ attributes_for(:user, email: "email_invalido@")}

			it "returns status code 422" do
				expect(response).to have_http_status(422)
			end

			it "returns the json data for the errors" do
				expect(json_body).to have_key('errors')
			end
		end
	end
	
	describe "PUT user/:id" do

		before do
			put "/users/#{user_id}", params: {user: user_params}, headers: headers

		end

		context "when the request params are valid" do
			let(:user_params){  {email: 'novo@email.com'}  }

			it "returns status code 200" do
				expect(response).to have_http_status(200)
			end

			it "returns json data for the updated user" do
				expect(json_body["email"]).to eq(user_params[:email])
			end
		end

		context "when the request params are invalid" do
			let(:user_params){  {email: 'novoemail@'}  }

			it "returns status code 422" do
				expect(response).to have_http_status(422)
			end

			it "returns the json data for the errors" do
				expect(json_body).to have_key('errors')
			end
		end
	end

	describe "DELETE user/:id" do
		before do
			delete "/users/#{user_id}", params: {}, headers: headers
		end

		it "returns status code 204" do
			expect(response).to have_http_status(204)
		end

		it "removes the user from database" do
			expect(User.find_by(id: user.id)).to be_nil
		end
	end
end
