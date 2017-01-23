require 'test_helper'

class OwnershipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ownership = ownerships(:one)

    @testing_data = {
      owner_id: 'test2@sanger.ac.uk',
      model_id: SecureRandom.uuid,
      model_type: 'set'
    }

    @batch_testing_data = [
        {
          owner_id: 'test2@sanger.ac.uk',
          model_id: ownerships(:one).model_id,
          model_type: 'set',
        },
        {
          owner_id: 'test3@sanger.ac.uk',
          model_id: ownerships(:two).model_id,
          model_type: 'biomaterial',
        },
        {
          owner_id: 'test4@sanger.ac.uk',
          model_id: SecureRandom.uuid,
          model_type: 'set',
        },
        {
          owner_id: 'test5@sanger.ac.uk',
          model_id: SecureRandom.uuid,
          model_type: 'set',
        },
    ]
  end

  test "should get index" do
    get ownerships_url, as: :json
    assert_response :success
  end

  test "should create ownership" do
    assert_difference('Ownership.count') do
      post ownerships_url, params: { ownership: @testing_data }, as: :json
    end

    assert_response :created
  end

  test "should show ownership" do
    get ownership_url(@ownership), as: :json
    assert_response :success
  end

  test "should partially update ownership" do
    assert_no_difference('Ownership.count') do
      patch ownership_url(@ownership), params: { ownership: { owner_id: @testing_data[:owner_id] } }, as: :json
    end

    assert_response :ok
  end

  test "should update ownership" do
    assert_no_difference('Ownership.count') do
      put ownership_url(@ownership), params: { ownership: @testing_data }, as: :json
    end

    assert_response :ok
  end  

  test "should destroy ownership" do
    assert_difference('Ownership.count', -1) do
      delete ownership_url(@ownership), as: :json
    end

    assert_response :no_content
  end

  test "should not create more than one ownerships with several create calls" do
    assert_difference('Ownership.count') do
      post ownerships_url, params: { ownership: @testing_data }, as: :json
      assert_response :created
    end
    assert_no_difference('Ownership.count') do
      2.times { 
        post ownerships_url, params: { ownership: @testing_data }, as: :json 
        assert_response :created
      }
    end 
  end

  test "should allow to partially update ownerships several times" do
    assert_no_difference('Ownership.count') do
      2.times { 
        patch ownership_url(@ownership), params: { ownership: { owner_id: @testing_data[:owner_id] } }, as: :json
        assert_response :ok
      }
    end
  end

  test "should allow me to change the owner of a model" do
    get ownership_url(@ownership), as: :json
    assert_response :ok
    get ownership_url(@testing_data), as: :json
    assert_response :not_found
    put ownership_url(@ownership), params: { ownership: @testing_data}, as: :json
    assert_response :ok
    get ownership_url(@ownership), as: :json
    assert_response :not_found
    get ownership_url(@testing_data), as: :json
    assert_response :ok
  end

  test "should allow to update ownerships several times" do
    assert_no_difference('Ownership.count') do
      2.times { 
        put ownership_url(@ownership), params: { ownership: @ownership }, as: :json 
        assert_response :ok
      }
    end
  end

  test "should batch upsert ownerships" do
    assert_difference('Ownership.count', 2) do
      post ownerships_batch_url, params: { ownership: @batch_testing_data }, as: :json
      ownerships(:one).reload
      ownerships(:two).reload
      assert_equal 'test2@sanger.ac.uk', ownerships(:one).owner_id
      assert_equal 'test3@sanger.ac.uk', ownerships(:two).owner_id
      assert_response :created
    end
  end

end
