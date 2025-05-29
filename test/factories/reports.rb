# frozen_string_literal: true

FactoryBot.define do
  factory :report do
    association :user
    title { 'Sample Report' }
    content { 'This is a sample report content.' }
  end
end
