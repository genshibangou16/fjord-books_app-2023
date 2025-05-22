# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :mentions_as_source, class_name: 'Mention', foreign_key: 'source_id', inverse_of: :source, dependent: :destroy
  has_many :mentioning_reports, through: :mentions_as_source, source: :target
  has_many :mentions_as_target, class_name: 'Mention', foreign_key: 'target_id', inverse_of: :target, dependent: :destroy
  has_many :mentioned_reports, through: :mentions_as_target, source: :source

  validates :title, presence: true
  validates :content, presence: true
  validate :mentioned_targets_must_exist

  after_create :sync_mentions
  after_update :sync_mentions, if: :saved_change_to_content?

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  private

  def extract_target_ids
    urls = content.to_s.scan(%r{http://localhost:3000/reports/\d+}).uniq
    urls.map do |url|
      target_id = url.split('/').last.to_i
      next if target_id == id

      target_id
    end.compact.uniq
  end

  def sync_mentions
    new_target_ids = extract_target_ids
    old_target_ids = mentions_as_source.pluck(:target_id)

    (new_target_ids - old_target_ids).each do |target_id|
      mentions_as_source.create!(target_id:)
    end

    to_remove = old_target_ids - new_target_ids
    mentions_as_source.where(target: to_remove).destroy_all if to_remove.any?
  end

  def mentioned_targets_must_exist
    target_ids = extract_target_ids
    missing_ids = target_ids - Report.where(id: target_ids).pluck(:id)
    return if missing_ids.empty?

    errors.add(:content, :invalid_mention, ids: missing_ids.join(', '))
  end
end
