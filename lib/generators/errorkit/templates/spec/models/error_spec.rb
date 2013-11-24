require 'spec_helper'

describe Error do
  let(:error) { Error.new }

  it "resolves errors" do
    now = Time.now
    Time.stub(:now).and_return(now)
    Error.should_receive(:update_attribute).with(:resolved_at, now)
    error.resolve!
  end

  it "does not resolve already resolved errors" do
    Error.should_not_receive(:update_attribute)
    error.resolved_at = Time.now
    error.resolve!
  end
end
