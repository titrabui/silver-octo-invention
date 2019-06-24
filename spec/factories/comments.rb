FactoryBot.define do
  factory :comment do
    content { "MyText" }
    message { nil }
    user { nil }
  end
end
