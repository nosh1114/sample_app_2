require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'invalid signup infomation' do
    get signup_path
    # 追加した結果大丈夫か？
    assert_no_difference 'User.count' do
      post users_path, params: { user: {
        name: '',
        email: 'user@shouldbeinvalid',
        password: 'hoge',
        password_confirmation: 'hoge'
      } }
    end
    # レスポンスが422 Unprocessable Entityであることを確認
    assert_response :unprocessable_entity
    # signupページにリダイレクトされることを確認
    assert_template 'users/new'
  end

  test 'valid signup information' do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: {
        name: 'valid user',
        email: 'valid@valid.com',
        password: 'validpassword',
        password_confirmation: 'validpassword'
      } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
