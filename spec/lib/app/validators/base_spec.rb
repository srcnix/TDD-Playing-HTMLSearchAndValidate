require_relative '../../../spec_helper'

describe Validators::Base do
  before(:all) do
    @user_agent = Validators::Base::USER_AGENT
    @validator  = Validators::Base.new
  end

  context '#initialize' do
    it 'should initialize an instance of Mechanize' do
      expect(Mechanize).to receive(:new).and_call_original

      Validators::Base.new
    end

    it 'should set a user_agent for Mechanize' do
      expect(@validator.agent.user_agent).to eql(@user_agent)
    end
  end

  context '#agent' do
    it 'should return an instance of Mechanize' do
      expect(@validator.agent).to be_a(Mechanize)
    end
  end
end
