FactoryGirl.define do
  factory :user do
#    name    "Memory Yuan"
#    email    "memory@qq.qq"
#    password "qqqqqq"
#    password_confirmation "qqqqqq"

    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "qqqqqq"
    password_confirmation "qqqqqq"
    
    factory :admin do
        #醬就可以用FactoryGirl.create(:admin)創建管理員
        admin true
    end
  end
end