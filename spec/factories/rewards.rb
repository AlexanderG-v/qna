FactoryBot.define do
  factory :reward do
    file_path = "#{Rails.root}/app/assets/images/badge.png"

    user
    name { 'MyReward' }
    association(:question)
    after :create do |reward|
      reward.image.attach(io: File.open(file_path), filename: 'badge.png')
    end
  end
end
