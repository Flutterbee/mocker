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

		res = Net::HTTP.get_response(uri)

		content_type = res['Content-Type']
		if content_type.include? "html"
			render html: res.body.html_safe, status: res.code
		else
			render json: res.body, status: res.code	
		end
	end

	def post
		uri = build_uri
		forward_params = params_to_forward

		if check_stub
			return
		end

		json_headers = {"Content-Type" => "application/json",
                "Accept" => "application/json"}

		http = Net::HTTP.new(uri.host, uri.port)

		res = http.post(uri.path, forward_params.to_json, json_headers)
		render json: res.body, status: res.code
	end

private
	def check_stub
		@stub = Stub.where(path: params[:path], is_active: true).take
		if @stub.nil?
			return false
		end
		
		stub_response = @stub.response
		if stub_response.include? "<html"
			render html: stub_response.html_safe
		else
			render json: stub_response
		end
		return true
	end

	def build_uri
		path = params[:path]
		return URI.parse(Rails.application.secrets['FORWARD_HOST'] + path)
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