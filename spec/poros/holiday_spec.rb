require 'rails_helper'

RSpec.describe Holiday do
 it 'exists and has attributes' do
   data =    {
    date: "2022-05-30",
    localName: "Memorial Day",
    name: "Memorial Day",
    countryCode: "US",
    types: [
      "Public"
    ]
  }
  holiday = Holiday.new(data)

  expect(holiday).to be_a(Holiday)
  expect(holiday.name).to eq(data[:name])
  expect(holiday.date).to eq(data[:date])
 end
end
