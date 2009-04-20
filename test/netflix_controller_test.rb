require File.dirname(__FILE__) + '/test_helper.rb'
require 'netflix_controller'
require 'action_controller/test_process'

class NetflixController; def rescue_action(e) raise e end; end

class NetflixControllerTest < ActionController::TestCase

	def setup 
#		@controller = WoodpeckersController.new 
#		@request = ActionController::TestRequest.new
#		@response = ActionController::TestResponse.new
##		ActionController::Routing::Routes.draw do |map|
#			map.resources :woodpeckers
#		end
	end

	def test_index
		get :index
		assert_redirected_to :controller => 'netflix', :action => 'titles'
	end
end 
