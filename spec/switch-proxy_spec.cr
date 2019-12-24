require "./spec_helper"

describe Switch::Proxy do
  describe Switch::Proxy::MyCli do
    it "check json is valid" do
      io = IO::Memory.new
      Switch::Proxy::MyCli.start(["check"], io: io)
      io.to_s.includes?("error").should be_false
    end
  end
end
