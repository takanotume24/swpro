require "./spec_helper"

describe Switch::Proxy do
  describe Switch::Proxy::MyCli do
    it "works" do
      io = IO::Memory.new
      Switch::Proxy::MyCli.start(["disable", "wget", "http://proxy.example.com:8080"], io: io)
      io.to_s.should eq "このコマンドは対応していません (>_<)\n"
    end
  end
end
