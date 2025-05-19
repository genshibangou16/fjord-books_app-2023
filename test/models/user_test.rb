# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'ユーザー名が登録されていれば名前を返す' do
    user = build(:user, name: 'test')
    assert_equal 'test', user.name_or_email
  end
  test 'ユーザー名が登録されていなければemailを返す' do
    user = build(:user, name: nil, email: 'test@example.com')
    assert_equal 'test@example.com', user.name_or_email
  end
end
