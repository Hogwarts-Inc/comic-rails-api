# frozen_string_literal: true

require 'test_helper'

class CanvasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @canva = canvas(:one)
  end

  test 'should get index' do
    get canvas_url, as: :json
    assert_response :success
  end

  test 'should create canva' do
    assert_difference('Canva.count') do
      post canvas_url, params: { canva: { image: @canva.image, title: @canva.title } }, as: :json
    end

    assert_response :created
  end

  test 'should show canva' do
    get canva_url(@canva), as: :json
    assert_response :success
  end

  test 'should update canva' do
    patch canva_url(@canva), params: { canva: { image: @canva.image, title: @canva.title } }, as: :json
    assert_response :success
  end

  test 'should destroy canva' do
    assert_difference('Canva.count', -1) do
      delete canva_url(@canva), as: :json
    end

    assert_response :no_content
  end
end
