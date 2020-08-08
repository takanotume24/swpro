require "../../src/helper/file_helper"
include Switch::Proxy::Helper::FileHelper

describe Switch::Proxy::Helper::FileHelper do
  it "is true when no elements are in the array" do
    ([] of Int32).empty?.should be_true
  end
  it "check_writable" do
    io = IO::Memory.new
    path = Path.new("/usr/bin/apt")
    check_writable path, io
    io.to_s.includes?("[ERRdOR]").should be_true
  end
end
