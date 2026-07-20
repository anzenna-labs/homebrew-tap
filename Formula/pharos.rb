class Pharos < Formula
  desc "Anzenna AI Audit hook enrolling against the production portal"
  homepage "https://anzenna.ai/"
  # URL is hardcoded per formula — pharos tracks production, pharos-test
  # tracks the test portal, pharos-staging tracks staging. The workflow
  # never rewrites this line; it reads it to know which portal to query.
  url "https://app.anzenna.ai/endpoint-binaries/ai-audit-demo/pharos-darwin-arm64.tgz"
  # PHAROS_PIN_BEGIN — managed by .github/workflows/update-formula.yml
  version "v0.201.2.1"
  sha256 "bbf93eeab4f5a6efd7c0b37c86256af7b00557e664731ddf2a2d523dc9eb89dd"
  # PHAROS_PIN_END
  license "Proprietary"

  depends_on arch: :arm64
  depends_on :macos

  # The pharos formulae install the same binaries — only one may be
  # active at a time.
  conflicts_with "pharos-test", because: "installs the same anzenna-ai-audit binaries"
  conflicts_with "pharos-staging", because: "installs the same anzenna-ai-audit binaries"
  conflicts_with "pharos-demo", because: "installs the same anzenna-ai-audit binaries"

  # Live channels install only the setup tool. The hook ships embedded in
  # it (written under managed-settings.d at install time) and the local
  # sink is a demo-only convenience, so it isn't placed on PATH here.
  def install
    bin.install "anzenna-ai-audit-setup"
  end

  def caveats
    <<~EOS
      Pharos (the Anzenna AI Audit hook) is installed under
      #{HOMEBREW_PREFIX}/bin.

      To enroll this device against your Anzenna production tenant and
      wire the hook into your AI agent, run (writes managed-settings, so
      it prompts for sudo):

        sudo anzenna-ai-audit-setup \\
          --portal-url https://app.anzenna.ai \\
          --domain YOUR_DOMAIN \\
          --enrollment-token YOUR_TOKEN

      You can omit --domain / --enrollment-token to be prompted, or set
      ANZENNA_DOMAIN / ANZENNA_ENROLLMENT_TOKEN in the environment. The
      device signing key is stored in the macOS keychain.

      Tear down configs/keys (binaries stay until `brew uninstall pharos`):
        sudo anzenna-ai-audit-setup --uninstall
    EOS
  end

  test do
    assert_predicate bin/"anzenna-ai-audit-setup", :executable?
  end
end
