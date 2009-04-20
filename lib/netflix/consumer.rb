class Netflix::Consumer < OAuth::Consumer

	def initialize
		consumer = super(
				Netflix.consumer_token,
				Netflix.consumer_secret,
				{
						:scheme            => :query_string,
						:http_method       => :post,
						:signature_method  => "HMAC-SHA1",
						:site              => "http://api.netflix.com",
						:request_token_url => Netflix::URL[:request],
						:access_token_url  => Netflix::URL[:access],
						:authorize_url     => Netflix::URL[:authorize]
				}
		)
	end

#	def get_request_token
##		Netflix::RequestToken(super)
##	it would be nice to be able to cast this as a Netflix::RequestToken
#		super
#	end

end
