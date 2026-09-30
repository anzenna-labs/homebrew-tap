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

1. Install the package:

   ```sh
   brew tap anzenna-labs/tap
   brew install anzenna-labs/tap/pharos
   ```

2. Read your Client Token into the environment. Run this line on its own,
   paste the token, and press Return; nothing is echoed:

   ```sh
   read -rs ANZENNA_CLIENT_TOKEN
   ```

3. Enroll the Mac, replacing `YOUR_DOMAIN` with your Anzenna domain, then
   clear the token:

   ```sh
   export ANZENNA_CLIENT_TOKEN
   sudo --preserve-env=ANZENNA_CLIENT_TOKEN anzenna-pharos-setup \
     --portal-url https://feed.anzenna.ai \
     --domain YOUR_DOMAIN
   unset ANZENNA_CLIENT_TOKEN
   ```

Passing the token through the environment keeps it out of your shell history
and off the installer's command line, where every process on the Mac could
read it.

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
