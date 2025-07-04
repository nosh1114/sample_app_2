require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  def setup
   @user = users(:michael)
  end
  test "account_activation" do
    # この辺よくわからない。
    @user.activation_token = User.new_token
    mail = UserMailer.account_activation(@user)
    assert_equal "Account activation", mail.subject
    assert_equal [@user.email], mail.to
    assert_equal ["nao.shiba.public@gmail.com"], mail.from
    # ここでは、include?と同じ内容が走っている。だから例えば、mailの内容に名前が入っていたらそれが問答無用で通ってしまう
    assert_match @user.name,               mail.body.encoded
    assert_match @user.activation_token,   mail.body.encoded
    assert_match CGI.escape(@user.email),  mail.body.encoded
  end

  test "password_reset" do

    @user.reset_token = User.new_token
    mail = UserMailer.password_reset(@user)
    assert_equal "Password reset", mail.subject
    assert_equal [@user.email], mail.to
    assert_equal ["nao.shiba.public@gmail.com"], mail.from
    assert_match @user.reset_token,        mail.body.encoded
    assert_match CGI.escape(@user.email),  mail.body.encoded
  end


end
