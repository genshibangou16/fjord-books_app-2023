# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test '自分の作成したレポートは編集可能' do
    user = build(:user)
    report = build(:report, user:)
    assert report.editable?(user)
  end
  test '他人の作成したレポートは編集不可' do
    poster = build(:user)
    viewer = build(:user)
    report = build(:report, user: poster)
    assert_not report.editable?(viewer)
  end
  test 'メンションが作成され、メンション元が参照できる' do
    mentioned = create(:report)
    report = create(:report, content: "http://localhost:3000/reports/#{mentioned.id}")
    assert_includes mentioned.mentioned_reports, report
  end
  test 'メンションが作成され、メンション先を参照できる' do
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
    report = build(:report, created_at: '2023-10-01 12:00:00')
    assert_equal Date.parse('2023-10-01'), report.created_on
  end
end
