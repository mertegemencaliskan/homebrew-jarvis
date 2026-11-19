class JarvisSwitch < Formula
  desc "Menu-bar status, model details and offload switch for a local OpenClaw assistant"
  homepage "https://github.com/mertegemencaliskan/jarvis-switch"
  url "https://github.com/mertegemencaliskan/jarvis-switch/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "1d4e6d333358d32dd0a860302b2d43c902c2af01cac5cc722d44328f09b8e127"
  license "MIT"
  head "https://github.com/mertegemencaliskan/jarvis-switch.git", branch: "main"

  depends_on :macos
  on_macos do
    depends_on macos: :ventura
  end

  def install
    system "scripts/build.sh", buildpath/"out"
    prefix.install buildpath/"out/JarvisSwitch.app"
    bin.install_symlink prefix/"JarvisSwitch.app/Contents/MacOS/JarvisSwitch" => "jarvis-switch"
  end

  service do
    run [opt_prefix/"JarvisSwitch.app/Contents/MacOS/JarvisSwitch"]
    keep_alive crashed: true
    process_type :interactive
    log_path var/"log/jarvis-switch.log"
    error_log_path var/"log/jarvis-switch.log"
  end

  def caveats
    <<~EOS
      Start it now and at every login:
        brew services start jarvis-switch
      Settings: ~/.config/jarvis-switch/config.json (menu > Edit settings...)
    EOS
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/jarvis-switch --version").strip
  end
end
