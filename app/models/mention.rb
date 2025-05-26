# frozen_string_literal: true

class Mention < ApplicationRecord
  belongs_to :target, class_name: 'Report', inverse_of: :mentions_as_target
  belongs_to :source, class_name: 'Report', inverse_of: :mentions_as_source

  validates :source_id, uniqueness: { scope: :target_id }
  validates :target_id, presence: true
  validates :source_id, presence: true
end
