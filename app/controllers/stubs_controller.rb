class StubsController < ApplicationController
	if (ENV['PASSWORD'] && ENV['USERNAME'])
		http_basic_authenticate_with name: ENV['USERNAME'], password: ENV['PASSWORD']
	end

	def new
		@stub = Stub.new
	end

	def create
		@stub = Stub.new(stub_params)

		if @stub.save
			redirect_to @stub
		else
			render 'new'
		end
	end

	def edit
		@stub = Stub.find(params[:id])
	end

	def update
		@stub = Stub.find(params[:id])
		if @stub.update(stub_params)
			redirect_to @stub
		else
			render 'edit'
		end
	end

	def destroy
		@stub = Stub.find(params[:id])
		@stub.destroy

		redirect_to stubs_path
	end

	def show
		@stub = Stub.find(params[:id])
	end

	def index
		@stubs = Stub.all

		
	end

	private
	def stub_params
		params.require(:stub).permit(:path, :response, :is_active)
		
	end

end
