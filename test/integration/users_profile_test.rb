require "test_helper"

class UsersProfileTest < ActionDispatch::IntegrationTest
  # なぜ呼び出す？
  include ApplicationHelper
  def setup
    @user = users(:michael)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'div.pagination'
    @user.microposts.paginate(page: 1).each do |micropost|
      # 1page画面全体の中からbodyにmicropostがそれぞれ一致しますか？
      assert_match micropost.content, response.body
    end
  end
end
