FactoryBot.define do
  factory :post do
    title { "MyString" }
    sub_title { "MyString" }
    description { "MyText" }
    user { nil }
  end
end
