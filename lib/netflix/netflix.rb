module Netflix

	URL = {
		:request   => "http://api.netflix.com/oauth/request_token",
		:authorize => "https://api-user.netflix.com/oauth/login",
		:access    => "http://api.netflix.com/oauth/access_token"
	}.freeze

	def self.creds
		@creds ||= begin
			ENV['RAILS_ROOT'] ||= File.dirname(__FILE__) + '/../../../../..' 
			rails_file = File.expand_path(File.join(ENV['RAILS_ROOT'], 'config/netflix.yml'))
			local_file = File.expand_path(File.join(File.dirname(__FILE__), '/../..', 'netflix.yml' ))
			if File.exist? rails_file
				YAML.load(File.open(rails_file))
			elsif File.exist? local_file
				YAML.load(File.open(local_file))
			else
				{
					:application_name => 'My_Netflix_Application_Name',
					:consumer_token   => 'My_Netflix_Consumer_Token',
					:consumer_secret  => 'My_Netflix_Consumer_Secret'
				}
			end
		end
	end

	def self.application_name
		creds[:application_name] || ''
	end

	def self.consumer_token
		creds[:consumer_token] || ''
	end

	def self.consumer_secret
		creds[:consumer_secret] || ''
	end

	def self.search(params={})
		if params.has_key?(:url)	
			path = params.delete(:url)
		elsif params.has_key?('url')	
			path = params.delete('url')
		elsif params.has_key?(:path)	
			path = params.delete(:path)
		elsif params.has_key?('path')	
			path = params.delete('path')
		else
			path = "/catalog/titles"
		end
		consumer = Netflix::Consumer.new
		if ![:oauth_token].blank? and !params[:oauth_token_secret].blank?
			#	If I understand this correctly, including the user's token and secret
			#	will allow for more API accesses and MAY include more info in the response.
			access_token = OAuth::AccessToken.new(consumer, params[:oauth_token], params[:oauth_token_secret] )
		else
			access_token = OAuth::AccessToken.new(consumer)
		end
		params_copy = params.dup
		params_copy.delete(:controller)
		params_copy.delete(:action)
		params_copy.delete(:oauth_token)
		params_copy.delete(:oauth_token_secret)
		# an ampersand in the search term causes failure so parse it out
		params_string = params_copy.keys.map { |key| "#{key}=#{params[key].to_s.gsub(/&/,'')}" }.join('&')
		access_token.get("#{path}?#{URI.escape(params_string)}")
	end

end
