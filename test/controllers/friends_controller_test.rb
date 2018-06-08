require 'test_helper'

class FriendsControllerTest < ActionDispatch::IntegrationTest
  test "should get update" do
    get friends_update_url
    assert_response :success
  end

end
