FactoryBot.define do
  factory :user do  # name属性を持つUserモデルを前提
    email { Faker::Internet.unique.email }
    password { '12345678' }
    password_confirmation { '12345678' }
    username { Faker::Name.name }
  end
end