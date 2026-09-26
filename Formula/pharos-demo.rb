class PharosDemo < Formula
  desc "Anzenna AI Audit hook with a local insights sink (demo, no portal)"
  homepage "https://anzenna.ai/"
  # PHAROS_DEMO_PIN_BEGIN — managed by .github/workflows/update-formula.yml
  version "v0.212.4-0.20260926022805-93730bdb32c1"
  sha256 "64742d09e2db1db232679b594f633bf26f84c75f18d32483f3d4b775ae4d942f"
  # PHAROS_DEMO_PIN_END
  # Versioned, immutable artifact URL: the portal serves the exact bytes
  # this version's manifest recorded, so the sha256 above stays valid
  # after later deploys move "latest" forward. The update workflow reads
  # this line for the portal + filename (it strips the /versions/#{version}
  # segment to build the /hash probe URL) and rewrites only the PIN block.
  url "https://app-test.anzenna.ai/endpoint-binaries/ai-audit-demo/versions/#{version}/pharos-darwin-arm64.tgz"
  license "Proprietary"

  depends_on arch: :arm64
  depends_on :macos

  conflicts_with "pharos", because: "installs the same anzenna-pharos binaries"
  conflicts_with "pharos-test", because: "installs the same anzenna-pharos binaries"
  conflicts_with "pharos-staging", because: "installs the same anzenna-pharos binaries"

  # Demo installs both the setup tool and the local sink — the demo flow
  # captures events to the sink and renders them with --insights. (The
  # hook itself ships embedded in the setup binary, which writes it under
  # managed-settings.d at install time.)
  def install
    bin.install "anzenna-pharos-setup"
    bin.install "anzenna-pharos-sink"
  end

  # Run the sink as a user LaunchAgent (require_root defaults false), so
  # it runs as the installing user and writes ~/.anzenna as that user.
  # --serve is the foreground mode; launchd owns the lifecycle and
  # restarts it, so we don't use --start (which self-detaches via Setsid).
  service do
    run [opt_bin/"anzenna-pharos-sink", "--serve", "--port", "7777"]
    keep_alive true
    log_path "#{Dir.home}/.anzenna/sink.log"
    error_log_path "#{Dir.home}/.anzenna/sink.log"
  end

  def caveats
    <<~EOS
      Pharos demo-channel build installed under #{HOMEBREW_PREFIX}/bin.

      Two steps to get going:

      1. Wire the hook into Claude Code (writes managed-settings; prompts
         for sudo):

           sudo anzenna-pharos-setup --demo

      2. Start the local sink on port 7777 (survives logout/reboot):

           brew services start pharos-demo

         If something else already holds :7777, the service will
         crash-loop; free the port or check `brew services list`.

      View captured events:
        anzenna-pharos-sink --insights
        open ~/.anzenna/insights.html

      To remove everything:
        brew services stop pharos-demo
        sudo anzenna-pharos-setup --uninstall
        brew uninstall pharos-demo
    EOS
  end

  test do
    assert_predicate bin/"anzenna-pharos-setup", :executable?
    assert_predicate bin/"anzenna-pharos-sink",  :executable?
  end
end
