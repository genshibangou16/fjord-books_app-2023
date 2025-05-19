# frozen_string_literal: true

FactoryBot.define do
  factory :book do
    title { 'Sample Book Title' }
    memo { 'Sample Book Memo' }
    author { 'Sample Author' }
  end
end
