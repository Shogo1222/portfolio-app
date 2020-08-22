FactoryBot.define do
  factory :logged_shop do
    shop_id { 'MyString' }
    user_id { 0 }
    action_from { 'test' }
    lat { 'test' }
    lng { 'test' }
    name { 'test' }
    catch { 'test' }
    capacity { 'test' }
    photo { 'test' }
    budget { 'test' }
    budget_memo { 'test' }
    mobile_access { 'test' }
    open { 'test' }
    non_smoking { 'test' }
    address { 'test' }
  end
end
