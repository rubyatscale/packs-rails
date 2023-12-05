require 'rails_helper'

RSpec.describe Foo do
  it 'can use the foo factory' do
    expect(FactoryBot.create(:foo, name: 'bar').name).to eq('bar')
  end
end