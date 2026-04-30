class Zap < Formula
  desc "Recursive URL expander"
  homepage "https://github.com/issmirnov/zap"
  url "https://github.com/issmirnov/zap/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "bfd3375cb2b26cdfac86edcce17ba7ab559aa24af64aa6450ceeb441da3279f1"
  license "MIT"
  head "https://github.com/issmirnov/zap.git", branch: "master"

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd"

    pkgetc.install "c.yml" unless (etc/"zap/c.yml").exist?
  end

  service do
    run [opt_bin/"zap", "-port", "8927"]
    working_dir etc/"zap"
    keep_alive true
    log_path var/"log/zap.log"
    error_log_path var/"log/zap.log"
  end

  def caveats
    <<~EOS
      Default config is at:
        #{etc}/zap/c.yml

      Edit it to add your URL shortcuts. zap supports hot reloading
      while running — no restart needed after edits.

      To start the daemon (binds the unprivileged port 8927):
        brew services start zap

      To bind port 80 (requires sudo):
        sudo brew services start zap

      Or run zap on its default unprivileged port and front it with a
      reverse proxy — see:
        https://github.com/issmirnov/zap
    EOS
  end

  test do
    system bin/"zap", "-v"
  end
end
