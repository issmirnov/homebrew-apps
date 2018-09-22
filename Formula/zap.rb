class Zap < Formula
  desc "Recursive URL expander"
  homepage "https://github.com/issmirnov/zap"
  url "https://github.com/issmirnov/zap/releases/download/v1.1.0/zap_MacOS_64-bit.tar.gz"
  version "1.1.0"
  sha256 "4512e7b992ee7d44a3260e2e8cc0b8b9809527fef28b91853f60635cbcf03105"

  bottle :unneeded

  def install
    bin.install "zap"
    (etc/"zap").mkpath
    (etc/"zap").install "c.yml"
  end

  def caveats
    s = <<~EOS
      #{name} will listen on port 80 for requests. Using config file:
      #{etc}/zap/c.yml. Zap supports hot reloading, so simply edit the
      file and try your new shortcuts.

      If you would like to run this as a system service, run
      `sudo brew services start zap`

      If you would like to run this behind a webserver proxy, see
      https://github.com/issmirnov/zap/blob/master/README.md#osx-brew.
      Be sure to update /etc/hosts with your shortcuts.

      NOTE: Please restart the service after upgrading!
    EOS
    s
  end

  plist_options :manual => "zap"
  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <false/>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}/etc/zap</string>
        <key>ProgramArguments</key>
        <array>
            <string>#{bin}/zap</string>
            <string>-port</string>
            <string>80</string>
        </array>
      </dict>
    </plist>
  EOS
  end

  test do
    system "#{bin}/zap", "-v"
  end
end
