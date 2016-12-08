require 'test_helper'

class OwnershipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ownership = ownerships(:one)

    @testing_data = {
      owner_id: 'test2@sanger.ac.uk',
      model_id: SecureRandom.uuid,
      model_type: 'set'
    }
  end

  test "should get index" do
    get ownerships_url, as: :json
    assert_response :success
  end

  test "should create ownership" do
    assert_difference('Ownership.count') do
      post ownerships_url, params: { ownership: @testing_data }, as: :json
    end

    assert_response 201
  end

  test "should show ownership" do
    get ownership_url(@ownership), as: :json
    assert_response :success
  end

  test "should partially update ownership" do
    assert_no_difference('Ownership.count') do
      patch ownership_url(@ownership), params: { ownership: { owner_id: @testing_data[:owner_id] } }, as: :json
    end

    assert_response 200
  end

  test "should update ownership" do
    assert_no_difference('Ownership.count') do
      put ownership_url(@ownership), params: { ownership: @testing_data }, as: :json
    end

    assert_response 200
  end  

  test "should destroy ownership" do
    assert_difference('Ownership.count', -1) do
      delete ownership_url(@ownership), as: :json
    end

    assert_response 204
  end

  test "should not create more than one ownerships with several create calls" do
    assert_difference('Ownership.count') do
      post ownerships_url, params: { ownership: @testing_data }, as: :json
      assert_response 201
    end
    assert_no_difference('Ownership.count') do
      2.times { 
        post ownerships_url, params: { ownership: @testing_data }, as: :json 
        assert_response 201
      }
    end 
  end

  test "should allow to partially update ownerships several times" do
    assert_no_difference('Ownership.count') do
      2.times { 
        patch ownership_url(@ownership), params: { ownership: { owner_id: @testing_data[:owner_id] } }, as: :json
        assert_response 200
      }
    end
  end

  test "should allow me to change the owner of a model" do
    get ownership_url(@ownership), as: :json
    assert_response :success
    assert_raises ActiveRecord::RecordNotFound do
      get ownership_url(@testing_data), as: :json
    end
    put ownership_url(@ownership), params: { ownership: @testing_data}, as: :json
    assert_response 200
    assert_raises ActiveRecord::RecordNotFound do
      get ownership_url(@ownership), as: :json
    end
    get ownership_url(@testing_data), as: :json
    assert_response 200
  end

  test "should allow to update ownerships several times" do
    assert_no_difference('Ownership.count') do
      2.times { 
        put ownership_url(@ownership), params: { ownership: @ownership }, as: :json 
        assert_response 200
      }
    end
  end


end
