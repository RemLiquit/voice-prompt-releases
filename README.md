# voice-prompt

Local, push-to-talk voice dictation for macOS. Hold a key, speak, release —
the transcribed, cleaned-up text is pasted wherever your cursor is.

This repository distributes compiled binaries only. Source code lives in a
private repository.

## Install

```
curl -fsSL https://raw.githubusercontent.com/RemLiquit/voice-prompt-releases/master/install.sh | sh
```

This downloads the latest release, installs it to `/Applications`, and
removes the macOS quarantine flag so it opens without the Gatekeeper warning
(the app isn't signed with a paid Developer ID certificate).

**Requirements:** macOS on Apple Silicon (arm64).

## Manual install

Download the `.zip` from [Releases](https://github.com/RemLiquit/voice-prompt-releases/releases),
unzip it, and drag `voice-prompt.app` to `/Applications`. On first launch,
right-click → Open to bypass the Gatekeeper warning.
