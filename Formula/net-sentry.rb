class NetSentry < Formula
  desc "Tiny macOS daemon that loudly alerts you when the internet drops"
  homepage "https://github.com/issmirnov/net-sentry"
  url "https://github.com/issmirnov/net-sentry/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "c230390a3f82961d2aade38a4eea7faf72325dbc5113897b4cdca31ac3c2179b"
  license "MIT"
  head "https://github.com/issmirnov/net-sentry.git", branch: "main"

  depends_on :macos
  depends_on xcode: ["14.0", :build]

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/net-sentry"
    pkgshare.install "config.example.toml"
  end

  def post_install
    config_dir = Pathname.new(Dir.home)/"Library/Application Support/net-sentry"
    config_file = config_dir/"config.toml"
    return if config_file.exist?

    config_dir.mkpath
    cp pkgshare/"config.example.toml", config_file
  end

  service do
    run [opt_bin/"net-sentry"]
    keep_alive true
    process_type :background
    log_path Pathname.new(Dir.home)/"Library/Logs/net-sentry.out.log"
    error_log_path Pathname.new(Dir.home)/"Library/Logs/net-sentry.err.log"
  end

  def caveats
    <<~EOS
      A default config has been seeded at:
        ~/Library/Application Support/net-sentry/config.toml

      To start the daemon (auto-starts on every login):
        brew services start net-sentry

      To reload after editing config:
        launchctl kickstart -k gui/$(id -u)/homebrew.mxcl.net-sentry

      Read more: https://github.com/issmirnov/net-sentry
    EOS
  end

  test do
    require "open3"
    Open3.popen3(bin/"net-sentry") do |_stdin, _stdout, stderr, wait_thr|
      sleep 1
      Process.kill("TERM", wait_thr.pid)
      output = stderr.read
      Process.wait(wait_thr.pid) rescue nil
      assert_match "net-sentry: running", output
    end
  end
end
