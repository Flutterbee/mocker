require 'uri'

class ProxyController < ApplicationController
skip_before_action :verify_authenticity_token

	def get
		uri = build_uri

		if check_stub
			return
		end
		forward_params = params_to_forward

		uri.query = URI.encode_www_form(forward_params)

		render json: Net::HTTP.get(uri)
	end

	def post
		uri = build_uri
		forward_params = params_to_forward

		json_headers = {"Content-Type" => "application/json",
                "Accept" => "application/json"}

		http = Net::HTTP.new(uri.host, uri.port)

		response = http.post(uri.path, forward_params.to_json, json_headers)
		render json: response.body
	end

private
	def check_stub
		@stub = Stub.where(path: params[:path], is_active: true).take
		if @stub.nil?
			return false
		end
		
		render json: @stub.response
		return true
	end

	def build_uri
		path = params[:path]
		return URI.parse(ENV['FORWARD_HOST'] + path)
	end

	def params_to_forward
		forward_params = params.clone
		forward_params.delete(:controller)
		forward_params.delete(:action)
		forward_params.delete(:path)
		forward_params.delete(:proxy)

		return forward_params
	end

end