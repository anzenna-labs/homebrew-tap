# Anzenna Homebrew Tap

Homebrew formulae for Anzenna tools.

| Formula | What it installs |
|---|---|
| `pharos` | Anzenna AI DLP for Apple Silicon Macs, enrolled against your Anzenna tenant |
| `pharos-demo` | A local-only demo of the same agent. Nothing leaves the machine and no Anzenna account is needed |

Only one of the two can be installed at a time.

The Homebrew install is intended for testing and evaluation on individual
Macs. It does not update itself. For fleet deployments, use your MDM as
described in the [AI DLP documentation](https://docs.anzenna.ai/docs/ai-dlp/overview).

## Install AI DLP

Contact [Anzenna support](mailto:support@anzenna.ai) first to have AI DLP
enabled for your domain, then follow the full guide at
[Install AI DLP via Homebrew](https://docs.anzenna.ai/docs/ai-dlp/homebrew).
The short version:

```sh
brew tap anzenna-labs/tap
brew install anzenna-labs/tap/pharos

read -rs ANZENNA_CLIENT_TOKEN
export ANZENNA_CLIENT_TOKEN
sudo --preserve-env=ANZENNA_CLIENT_TOKEN anzenna-pharos-setup \
  --portal-url https://feed.anzenna.ai \
  --domain YOUR_DOMAIN
unset ANZENNA_CLIENT_TOKEN
```

After `read -rs`, paste your Client Token and press Return; nothing is echoed.
Reading the token into the environment keeps it out of your shell history
and out of the process list while the installer runs.

To uninstall, remove the agent before the package, since the package provides
the uninstaller:

```sh
sudo anzenna-pharos-setup --uninstall
brew uninstall pharos
```

## Try the demo

The demo wires the hook into Claude Code, runs a local sink on port 7777, and
renders captured events to `~/.anzenna/insights.html`:

```sh
brew tap anzenna-labs/tap
brew install anzenna-labs/tap/pharos-demo
sudo anzenna-pharos-setup --demo
brew services start pharos-demo
anzenna-pharos-sink --insights
```

To remove it:

```sh
brew services stop pharos-demo
sudo anzenna-pharos-setup --uninstall
brew uninstall pharos-demo
```

## Reporting a security issue

Email [security@anzenna.ai](mailto:security@anzenna.ai) rather than opening a
public issue.
