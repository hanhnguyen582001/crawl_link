require "test_helper"

class SearchLinkControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get search_link_index_url
    assert_response :success
  end
end
