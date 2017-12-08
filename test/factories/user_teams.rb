# frozen_string_literal: true

require 'ffaker'

FactoryBot.define do
  factory :user_team do
    name { FFaker::Lorem.words(rand(3..5)).join(' ').titleize }
  end
end
