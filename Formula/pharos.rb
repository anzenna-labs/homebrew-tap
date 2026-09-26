class Pharos < Formula
  desc "Anzenna AI Audit hook enrolling against the production portal"
  homepage "https://anzenna.ai/"
  # PHAROS_PIN_BEGIN — managed by .github/workflows/update-formula.yml
  version "v0.212.1"
  sha256 "59d0bd74435568eca4641c6b14cffa6116e9243c6cd030ab25bade1d46432dab"
  # PHAROS_PIN_END
  # Versioned, immutable artifact URL: the portal serves the exact bytes
  # this version's manifest recorded, so the sha256 above stays valid
  # after later deploys move "latest" forward. The update workflow reads
  # this line for the portal + filename (it strips the /versions/#{version}
  # segment to build the /hash probe URL) and rewrites only the PIN block.
  url "https://app.anzenna.ai/endpoint-binaries/ai-audit-demo/versions/#{version}/pharos-darwin-arm64.tgz"
  license "Proprietary"

  depends_on arch: :arm64
  depends_on :macos

  # The pharos formulae install the same binaries — only one may be
  # active at a time.
  conflicts_with "pharos-test", because: "installs the same anzenna-pharos binaries"
  conflicts_with "pharos-staging", because: "installs the same anzenna-pharos binaries"
  conflicts_with "pharos-demo", because: "installs the same anzenna-pharos binaries"

  # Live channels install only the setup tool. The hook ships embedded in
  # it (written under managed-settings.d at install time) and the local
  # sink is a demo-only convenience, so it isn't placed on PATH here.
  def install
    bin.install "anzenna-pharos-setup"
  end

  def caveats
    <<~EOS
      Pharos (the Anzenna AI Audit hook) is installed under
      #{HOMEBREW_PREFIX}/bin.

      To enroll this device against your Anzenna production tenant and
      wire the hook into your AI agent, run (writes managed-settings, so
      it prompts for sudo):

        sudo anzenna-pharos-setup \\
          --portal-url https://feed.anzenna.ai \\
          --domain YOUR_DOMAIN \\
          --client-token YOUR_CLIENT_TOKEN

      Your Client Token is shown in the Anzenna portal. You can omit
      --domain / --client-token to be prompted, or set ANZENNA_DOMAIN /
      ANZENNA_CLIENT_TOKEN in the environment — preferred for the token,
      since a command-line argument is visible to every process on the
      machine while the installer runs. The device signing key is stored
      in the macOS keychain.

      Tear down configs/keys (binaries stay until `brew uninstall pharos`):
        sudo anzenna-pharos-setup --uninstall
    EOS
  end

  test do
    assert_predicate bin/"anzenna-pharos-setup", :executable?
  end
end
