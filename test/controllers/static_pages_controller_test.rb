require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  # 繰り返しを避けるために、テストの前に実行する処理をsetupメソッドにまとめる
  def setup
    @base_title = 'Ruby on Rails Tutorial Sample App'
  end
  # テストの内容
  # 1. homeアクションにGETリクエストを送信
  # 2. レスポンスが成功したことを確認
  test 'should get home' do
    get static_pages_home_url
    assert_response :success
    assert_select 'title', "Home | #{@base_title}"
  end

  # テストの内容
  # 1. helpアクションにGETリクエストを送信
  # 2. レスポンスが成功したことを確認
  test 'should get help' do
    get static_pages_help_url
    # assertの意味は、
    assert_response :success
    assert_select 'title', "Help | #{@base_title}"
  end

  test 'should get about' do
    get static_pages_about_url
    assert_response :success
    assert_select 'title', "About | #{@base_title}"
  end

  test 'should get contact' do
    get static_pages_contact_url
    assert_response :success
    assert_select 'title', "Contact | #{@base_title}"
  end
end
