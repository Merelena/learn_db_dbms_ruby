require "test_helper"

class EduInstitutionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @edu_institution = edu_institutions(:one)
  end

  test "should get index" do
    get edu_institutions_url, as: :json
    assert_response :success
  end

  test "should create edu_institution" do
    assert_difference('EduInstitution.count') do
      post edu_institutions_url, params: { edu_institution: { city: @edu_institution.city, edu_institution: @edu_institution.edu_institution } }, as: :json
    end

    assert_response 201
  end

  test "should show edu_institution" do
    get edu_institution_url(@edu_institution), as: :json
    assert_response :success
  end

  test "should update edu_institution" do
    patch edu_institution_url(@edu_institution), params: { edu_institution: { city: @edu_institution.city, edu_institution: @edu_institution.edu_institution } }, as: :json
    assert_response 200
  end

  test "should destroy edu_institution" do
    assert_difference('EduInstitution.count', -1) do
      delete edu_institution_url(@edu_institution), as: :json
    end

    assert_response 204
  end
end
