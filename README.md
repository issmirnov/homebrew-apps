# Ivan's Homebrew Tap

Simple repo to distribute apps I build via Homebrew.

```bash
brew tap issmirnov/apps
```

## Formulae

### net-sentry

Tiny macOS daemon that loudly alerts you when the internet drops — voice + modal + notification.

- Source: <https://github.com/issmirnov/net-sentry>
- Install:

  ```bash
  brew install issmirnov/apps/net-sentry
  brew services start net-sentry
  ```

### zap

Recursive URL expander.

- Source: <https://github.com/issmirnov/zap>
- Install:

  ```bash
  brew install issmirnov/apps/zap
  ```

## Updating a formula

```bash
# Apple Silicon path; on Intel use /usr/local/Homebrew/...
cd "$(brew --repository)/Library/Taps/issmirnov/homebrew-apps/"
$EDITOR Formula/<name>.rb
brew audit --strict --online <name>
git push
```

GitHub Actions runs `brew test-bot` on every PR (lint + build + test) — see [`.github/workflows/tests.yml`](.github/workflows/tests.yml).
