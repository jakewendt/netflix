$:.unshift File.dirname(__FILE__)

require 'oauth'
require 'hpricot'
require 'oauth/consumer'
require 'netflix/netflix'
require 'netflix/consumer'
#require 'netflix/core_ext'

unless ENV['RAILS_ENV'].nil?
	ActionController::Routing.controller_paths.push(File.join(File.dirname(__FILE__), 'app/controllers'))
	ActionController::Base.append_view_path(File.join(File.dirname(__FILE__), 'app/views'))

	#	Tried adding 'views' to this, but doesn't seem to help
	#	Can't access the controller without explicitly adding route to config/routes.rb
	%w{ models controllers helpers }.each do |dir|
		path = File.join(File.dirname(__FILE__), 'app', dir)
		$LOAD_PATH << path
	
		ActiveSupport::Dependencies.load_paths << path
		ActiveSupport::Dependencies.autoload_once_paths.delete(path)
	end
end

#	can't do this cause ...  well, I don't know
#class Rails::Configuration
#
#private
#
#	def default_controller_paths
#		paths = [File.join(root_path, 'app', 'controllers')]
#		paths.concat builtin_directories
#		paths.concat [File.join(File.dirname(__FILE__), 'app/controllers')]
#		paths
#	end
#
#end

#
#	Can override the initialize_routing method this, but I don't like it.
#	Can remove this if you don't want the controller included in this plugin.
#
class Rails::Initializer

	def initialize_routing
		return unless configuration.frameworks.include?(:action_controller)
#		ActionController::Routing.controller_paths = configuration.controller_paths
#		ActionController::Routing.controller_paths.push(File.join(File.dirname(__FILE__), 'app/controllers'))
#	this mod is actually in the latest code (090419)
		ActionController::Routing.controller_paths += configuration.controller_paths
		ActionController::Routing::Routes.configuration_file = configuration.routes_configuration_file
		ActionController::Routing::Routes.reload
	end

end

