class Zap < Formula
  desc "Recursive URL expander"
  homepage "https://github.com/issmirnov/zap"
  url "https://github.com/issmirnov/zap/releases/download/v0.9.6/zap_MacOS_64-bit.tar.gz"
  version "0.9.6"
  sha256 "e37a291875d84af3083c9bfcb8f2e4de86b56024109f99643017adb3bd73db9c"

  bottle :unneeded

  def install
    bin.install "zap"
    (etc/"zap").mkpath
    (etc/"zap").install "c.yml"
  end

  test do
    system "#{bin}/zap", "-v"
  end

  def caveats
    s = <<-EOS.undent
    #{name} will listen on port 80 for requests. Using config file:
    #{etc}/zap/c.yml. Zap supports hot reloading, so simply edit the
    file and try your new shortcuts.
    
    If you would like to run this as a system service, simply run 
    `sudo brew services start zap`
    
    If you would like to run this behind a webserver proxy, see 
    https://github.com/issmirnov/zap/blob/master/README.md#osx-brew.
    Be sure to update /etc/hosts with your shortcuts.

    NOTE: Please restart the service after upgrading!
    EOS
    s
  end

  def plist;
  <<-EOS.undent
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
end
