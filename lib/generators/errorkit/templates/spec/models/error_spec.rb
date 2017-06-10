require 'rails_helper'

RSpec.describe Error, type: :model do
  let(:error) { Error.new }

  it "resolves errors" do
    now = Time.now
    allow(Time).to receive(:now).and_return(now)
    expect(error).to receive(:update_attribute).with(:resolved_at, now)
    error.resolve!
  end

  it "does not resolve already resolved errors" do
    expect(error).to_not receive(:update_attribute)
    error.resolved_at = Time.now
    error.resolve!
  end
end
