require "../../src/helper/file_helper"
include Switch::Proxy::Helper::FileHelper
include Switch::Proxy::Config

describe Switch::Proxy::Helper::FileHelper do
  describe "#check_writable" do
    it "A file that shouldn't be able to be written." do
      io = IO::Memory.new
      path = Path.new("/usr/bin/apt")
      check_writable(path, io).should be_nil
    end
    it "A file that could be written to." do 
      io = IO::Memory.new
      path = Path.new(UserConfig.get_path)
      check_writable(path, io).should be_nil
    end
  end
end
