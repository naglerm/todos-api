FactoryGirl.define do
  factory :user do
    name {Faker::Name.name}
    email 'foobar@example.com'
    password 'foobar'
  end
end
