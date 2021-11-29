FactoryBot.define do
  factory :message do
    user { nil }
    chatroom { nil }
    body { "MyText" }
  end
end