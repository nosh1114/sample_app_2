class ApplicationController < ActionController::Base
  # sessions周りのログイン機構はどの部分でも使うことになるので、全クラスの親クラスに読み込ませ、どこでも読み込ませられるようにする。
  include SessionsHelper
end
