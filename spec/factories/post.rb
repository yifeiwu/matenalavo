require 'faker'

# then, whenever you need to clean the DB

FactoryGirl.define do
  factory :post do |p|
    p.contact { Faker::Internet.email }
    p.content { Faker::Lorem.sentences }
    p.title   { Faker::Name.title }
  end

  factory :invalid_title, parent: :post do |p|
    p.title nil
  end
end
