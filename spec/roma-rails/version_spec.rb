require 'spec_helper'

describe RomaRails::VERSION do
  it "check version string" do
    RomaRails::VERSION::STRING.should ==
      "#{RomaRails::VERSION::MAJOR}." +
      "#{RomaRails::VERSION::MINOR}." +
      "#{RomaRails::VERSION::TINY}"
  end
end
