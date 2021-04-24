require "test_helper"

class EduAidsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @edu_aid = edu_aids(:one)
  end

  test "should get index" do
    get edu_aids_url, as: :json
    assert_response :success
  end

  test "should create edu_aid" do
    assert_difference('EduAid.count') do
      post edu_aids_url, params: { edu_aid: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show edu_aid" do
    get edu_aid_url(@edu_aid), as: :json
    assert_response :success
  end

  test "should update edu_aid" do
    patch edu_aid_url(@edu_aid), params: { edu_aid: {  } }, as: :json
    assert_response 200
  end

  test "should destroy edu_aid" do
    assert_difference('EduAid.count', -1) do
      delete edu_aid_url(@edu_aid), as: :json
    end

    assert_response 204
  end
end
