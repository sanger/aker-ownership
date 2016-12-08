require 'test_helper'

class OwnershipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ownership = ownerships(:one)
  end

  test "should get index" do
    get ownerships_url, as: :json
    assert_response :success
  end

  test "should create ownership" do
    assert_difference('Ownership.count') do
      post ownerships_url, params: { ownership: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show ownership" do
    get ownership_url(@ownership), as: :json
    assert_response :success
  end

  test "should update ownership" do
    patch ownership_url(@ownership), params: { ownership: {  } }, as: :json
    assert_response 200
  end

  test "should destroy ownership" do
    assert_difference('Ownership.count', -1) do
      delete ownership_url(@ownership), as: :json
    end

    assert_response 204
  end
end
