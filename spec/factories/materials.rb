FactoryBot.define do
  factory :material do
    title { "MyString" }
    description { "MyText" }
    status { "MyString" }
    type { "" }
    user { nil }
    author { nil }
    isbn { "MyString" }
    pages { 1 }
    doi { "MyString" }
    duration_in_minutes { 1 }
  end
end
