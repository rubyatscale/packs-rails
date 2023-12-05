require 'rails_helper'

RSpec.describe Bar do
  it 'can use the foo factory' do
    expect(FactoryBot.create(:bar, name: 'baz').name).to eq('baz')
  end
end