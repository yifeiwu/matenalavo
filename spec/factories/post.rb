require 'faker'

FactoryGirl.define do
  factory :post do |p|
    p.contact { Faker::Internet.email }
    p.content { Faker::Lorem.sentences }
    p.title   { Faker::Name.title }
  end
end