class Zap < Formula
  desc "Recursive URL expander"
  homepage "https://github.com/issmirnov/zap"
  url "https://github.com/issmirnov/zap/releases/download/0.9.0/zap"
  sha256 "8dd6fcab9588c452951911612e4301dd7fef90ad6130164330b3bfffe0add1dc"

  bottle :unneeded

  def install
    bin.install "zap"
  end

  test do
    system "#{bin}/zap", "-v"
  end
end
