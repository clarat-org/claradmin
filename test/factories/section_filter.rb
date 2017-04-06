FactoryGirl.define do
  factory :section_filter do
    transient do
      _random do
        [%w(family Family), %w(refugees Refugees)].sample
      end
    end
    identifier { _random[0] }
    name { _random[1] }
  end
end