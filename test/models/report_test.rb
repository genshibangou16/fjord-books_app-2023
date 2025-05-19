# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test '自分の作成したレポートは編集可能' do
    user = create(:user)
    report = create(:report, user:)
    assert report.editable?(user)
  end
  test '他人の作成したレポートは編集不可' do
    user1 = create(:user)
    user2 = create(:user)
    report = create(:report, user: user1)
    assert_not report.editable?(user2)
  end
  test 'メンション元が正しい' do
    mentioned = create(:report)
    report = create(:report, content: "http://localhost:3000/reports/#{mentioned.id}")
    assert_includes mentioned.mentioned_reports, report
  end
  test 'メンション先が正しい' do
    mentioned = create(:report)
    report = create(:report, content: "http://localhost:3000/reports/#{mentioned.id}")
    assert_includes report.mentioning_reports, mentioned
  end
  test 'メンションが更新される' do
    mentioned1 = create(:report)
    mentioned2 = create(:report)
    report = create(:report, content: "http://localhost:3000/reports/#{mentioned1.id}")
    assert_includes report.mentioning_reports, mentioned1
    report.update!(content: "http://localhost:3000/reports/#{mentioned2.id}")
    report.reload
    assert_not_includes report.mentioning_reports, mentioned1
    assert_includes report.mentioning_reports, mentioned2
  end
  test '作成日時が取得できる' do
    report = create(:report)
    assert_equal report.created_on, report.created_at.to_date
  end
end
