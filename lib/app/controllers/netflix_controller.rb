class NetflixController < ApplicationController
	before_filter :set_consumer, :except => [ :index ]
	before_filter :require_authorization, :only => [ :queue, :instant, :home, :recommendations ]

	def index
		redirect_to :controller => 'netflix', :action => 'titles'
	end

	def titles
		params_copy = params.dup.delete_keys!(:action,:controller,:oauth_token,:oauth_token_secret)
		@results = Netflix.search({:url => '/catalog/titles'}.merge(params_copy))
		# returns nil rather than returning an empty array if no matches
		@titles = XmlSimple.xml_in(@results.body)['catalog_title']||[]
	end

	def people
		params_copy = params.dup.delete_keys!(:action,:controller,:oauth_token,:oauth_token_secret)
		@results = Netflix.search({:url => '/catalog/people'}.merge(params_copy))
		# returns nil rather than returning an empty array if no matches
		@people = XmlSimple.xml_in(@results.body)['person']||[]
	end

	def queue
		@results = @access_token.get("/users/#{session[:netflix_user_id]}/queues/disc")
		# returns nil rather than returning an empty array if no matches
		@titles = XmlSimple.xml_in(@results.body)['queue_item']||[]
		render :action => "titles"
	end

	def instant
		@results = @access_token.get("/users/#{session[:netflix_user_id]}/queues/instant")
		# returns nil rather than returning an empty array if no matches
		@titles = XmlSimple.xml_in(@results.body)['queue_item']||[]
		render :action => "titles"
	end

	def home
		@results = @access_token.get("/users/#{session[:netflix_user_id]}/at_home")
		# returns nil rather than returning an empty array if no matches
		@titles = XmlSimple.xml_in(@results.body)['at_home_item']||[]
		render :action => "titles"
	end

	def recommendations
		@results = @access_token.get("/users/#{session[:netflix_user_id]}/recommendations")
		# returns nil rather than returning an empty array if no matches
		@titles = XmlSimple.xml_in(@results.body)['recommendation']||[]
		render :action => "titles"
	end

	def logout
		reset_session
		redirect_to :controller => 'netflix', :action => 'titles'
	end

protected

	def set_consumer
		@consumer = Netflix::Consumer.new
#		@consumer = OAuth::Consumer.new(
#				Netflix.consumer_token,
#				Netflix.consumer_secret,
#				{
#						:scheme            => :query_string,
#						:http_method       => :post,
#						:signature_method  => "HMAC-SHA1",
#						:site              => "http://api.netflix.com",
#						:request_token_url => Netflix::URL[:request],
#						:access_token_url  => Netflix::URL[:access],
#						:authorize_url     => Netflix::URL[:authorize]
#				}
#		)
	end

	def require_authorization
		if !session[:netflix_user_id].blank? and !session[:oauth_token].blank? and !session[:oauth_token_secret].blank?
			@access_token = OAuth::AccessToken.new( @consumer, session[:oauth_token], session[:oauth_token_secret])
		elsif !session[:token].blank? and !session[:secret].blank?
			request_token = @consumer.get_request_token
			request_token.token  = session[:token]	#	I don't like doing this
			request_token.secret = session[:secret]	#	I don't like doing this
			@access_token = request_token.get_access_token
			session[:token]  = nil	#	would like to delete the key, but apparently can't
			session[:secret] = nil	#	would like to delete the key, but apparently can't
			session[:oauth_token]        = @access_token.params[:oauth_token]
			session[:oauth_token_secret] = @access_token.params[:oauth_token_secret]
			session[:netflix_user_id]    = @access_token.params[:user_id]  # be careful with user_id in case I set one
		else
			request_token = @consumer.get_request_token
			session[:token] = request_token.token
			session[:secret] = request_token.secret
			redirect_to request_token.authorize_url({ 
				"application_name"   => Netflix.application_name, 
				"oauth_consumer_key" => Netflix.consumer_token,
				'oauth_callback'     => request.url
			})
		end
	end

end

class ::Hash

	def delete_keys!(*keys)
		keys.each do |k| 
			self.delete(k)
		end 
		self
	end 

end
