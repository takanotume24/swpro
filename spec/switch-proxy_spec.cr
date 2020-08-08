require "./spec_helper"

describe Switch::Proxy do
  describe Switch::Proxy::MyCli do
    before_all do
      io = IO::Memory.new
      Switch::Proxy::MyCli.start(["internal", "cp_json"], io: io)
    end
    it "check json is valid" do
      io = IO::Memory.new
      Switch::Proxy::MyCli.start(["check"], io: io)
      io.to_s.includes?("error").should be_false
    end
  end
end
