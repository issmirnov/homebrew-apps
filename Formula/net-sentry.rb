class NetSentry < Formula
  desc "Tiny macOS daemon that loudly alerts you when the internet drops"
  homepage "https://github.com/issmirnov/net-sentry"
  url "https://github.com/issmirnov/net-sentry/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "c230390a3f82961d2aade38a4eea7faf72325dbc5113897b4cdca31ac3c2179b"
  license "MIT"
  head "https://github.com/issmirnov/net-sentry.git", branch: "main"

  depends_on xcode: ["14.0", :build]
  depends_on :macos

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/net-sentry"
    pkgshare.install "config.example.toml"
  end

  service do
    run [opt_bin/"net-sentry"]
    keep_alive true
    process_type :background
    log_path var/"log/net-sentry.out.log"
    error_log_path var/"log/net-sentry.err.log"
  end

  def caveats
    <<~EOS
      net-sentry runs with sane built-in defaults; no config file is required.
      To customize alert text, voice, debounce, or which channels fire, copy
      the example config to your home directory and edit it:

        mkdir -p "$HOME/Library/Application Support/net-sentry"
        cp #{pkgshare}/config.example.toml \\
           "$HOME/Library/Application Support/net-sentry/config.toml"

      Then reload the daemon to pick up changes:
        launchctl kickstart -k gui/$(id -u)/homebrew.mxcl.net-sentry

      To start the daemon (auto-starts on every login):
        brew services start net-sentry

      Logs:
        #{var}/log/net-sentry.out.log
        #{var}/log/net-sentry.err.log

      Read more: https://github.com/issmirnov/net-sentry
    EOS
  end

  test do
    require "open3"
    Open3.popen3(bin/"net-sentry") do |_stdin, _stdout, stderr, wait_thr|
      sleep 1
      Process.kill("TERM", wait_thr.pid)
      output = stderr.read
      assert_match "net-sentry: running", output
      # Open3.popen3 with a block reaps via wait_thr.value at block exit.
    end
  end
end
