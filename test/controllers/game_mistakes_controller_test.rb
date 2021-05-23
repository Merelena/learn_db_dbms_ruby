require "test_helper"

class GameMistakesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @game_mistake = game_mistakes(:one)
  end

  test "should get index" do
    get game_mistakes_url, as: :json
    assert_response :success
  end

  test "should create game_mistake" do
    assert_difference('GameMistake.count') do
      post game_mistakes_url, params: { game_mistake: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show game_mistake" do
    get game_mistake_url(@game_mistake), as: :json
    assert_response :success
  end

  test "should update game_mistake" do
    patch game_mistake_url(@game_mistake), params: { game_mistake: {  } }, as: :json
    assert_response 200
  end

  test "should destroy game_mistake" do
    assert_difference('GameMistake.count', -1) do
      delete game_mistake_url(@game_mistake), as: :json
    end

    assert_response 204
  end
end
