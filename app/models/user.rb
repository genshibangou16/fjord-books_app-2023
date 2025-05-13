# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end

  validate :correct_document_mime_type

  private

  def correct_document_mime_type
    return unless avatar.attached? && !avatar.content_type.start_with?('image/')

    errors.add(:avatar, :must_be_image)
  end
end
