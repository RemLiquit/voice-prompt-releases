# voice-prompt

**Hold a key. Speak your thoughts. Paste a clearer version.**

Dictate into the app you're using, clean up spoken ideas, or turn them into a
prompt for an AI agent. voice-prompt records while you hold a key, transcribes
when you release it, and can rewrite the result before pasting.

Choose local models or bring your own cloud API keys. The interface and writing
modes are in Spanish, with configurable transcription language.

**[Download the latest release](https://github.com/RemLiquit/voice-prompt-releases/releases/latest)**
· [What's new in 0.1.4](https://github.com/RemLiquit/voice-prompt-releases/releases/tag/v0.1.4)
· [First run](#first-run)
· [Troubleshooting](#troubleshooting)

This repository distributes compiled binaries. The source code is maintained
in a private repository.

## Features

- **Dictate with one key:** hold to record, release to process, or press Escape
  while recording to cancel. A floating HUD shows your audio level and progress.
- **Four writing modes:** keep the transcript, clean up filler words, organize
  ideas, or create an instruction for an AI agent.
- **Editable prompts and vocabulary:** personalize rewriting and supply names,
  tools, and technical terms you dictate often.
- **Local or cloud processing:** choose transcription and rewriting separately.
- **Guided setup:** check providers and test rewriting before you start dictating.
- **Menu bar controls on macOS:** reopen Settings, run diagnostics, and check
  for updates. Settings supports system, light, and dark themes.

## Installation

### macOS — Apple Silicon

Download **`voice-prompt-macos-arm64.zip`** from the
[latest release](https://github.com/RemLiquit/voice-prompt-releases/releases/latest),
extract it, and move `voice-prompt.app` to `/Applications`.

Alternatively, install the latest macOS version from Terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/RemLiquit/voice-prompt-releases/master/install.sh | bash
open -a voice-prompt
```

The installer closes a running copy, replaces the app in `/Applications`, and
clears its quarantine attributes. Release builds use an ad-hoc signature and
are not Developer ID signed or notarized. See [Troubleshooting](#troubleshooting)
if macOS blocks a manually downloaded app.

Only **Apple Silicon (arm64)** builds are published. **Apple SpeechAnalyzer
requires macOS 26+**; local whisper.cpp and cloud transcription are separate
options. The app lives in the menu bar rather than the Dock.

### Windows — x64, experimental

Download the file ending in **`-setup-experimental.exe`** from the
[latest release](https://github.com/RemLiquit/voice-prompt-releases/releases/latest)
and run the installer. Enable microphone access for desktop apps in Windows
Settings before recording. The default dictation key is **right Control**.

### Linux — x86_64, experimental

Use an **X11 desktop session** and download a **DEB** or **AppImage** from the
[latest release](https://github.com/RemLiquit/voice-prompt-releases/releases/latest).
For the 0.1.4 DEB, run this from the download directory:

```bash
sudo apt install ./voice-prompt_0.1.4_amd64-experimental.deb
```

Or make the AppImage executable and run it:

```bash
chmod +x ./voice-prompt_0.1.4_amd64-experimental.AppImage
./voice-prompt_0.1.4_amd64-experimental.AppImage
```

Use the matching filename for newer versions. Your session needs working audio
input and a Secret Service credential store for API keys. The default dictation
key is **right Control**. Native Wayland and XWayland under a Wayland desktop
are outside the global hotkey implementation's scope.

### Experimental platform limitations

Windows and Linux packages compile and are packaged in CI, but the full
dictation flow has not been verified on real desktops. **Automatic paste still
uses macOS-specific key handling**, and some permission checks, diagnostics,
and interface text remain macOS-oriented. These packages are available for
testing; they do not yet have the same level of support as macOS.

## First run

1. **Open the app and grant permissions.** On macOS, allow Microphone and
   Accessibility access. On Windows, check microphone access in system settings.
2. **Choose transcription.** The wizard selects Apple SpeechAnalyzer when
   available on macOS 26+, or Groq otherwise. Test the selected provider.
3. **Choose rewriting.** Groq is initially selected in the graphical wizard.
   Add your API key, or select Ollama for local processing, then test it.
4. **Choose a mode and key.** Adjust the prompt and vocabulary if needed, then
   save. On macOS, the default key is **right Command (⌘)**.
5. **Dictate.** Focus a text field, hold your key until the HUD appears, speak,
   and release. The default hold threshold is **400 ms**.

Existing saved provider choices are retained when you reopen Settings. Open
**Ajustes…** from the menu bar to change your configuration.

## Writing modes

- **Crudo:** return the transcript without an LLM rewriting request.
- **Limpiar:** remove filler words and fix punctuation without reordering ideas.
- **Estructurar:** organize related ideas and use lists where useful. This is
  the default mode.
- **Prompt para IA:** turn a spoken request into a clear instruction for an agent.

The prompts aim to preserve your language and meaning without adding
information. You can edit the three rewriting prompts in Settings. If a
rewriting request fails, the app falls back to the original transcript.

## Providers and local setup

**Transcription — audio to text**

- **Apple SpeechAnalyzer:** on-device, macOS 26+. Apple manages language assets
  and may download them on first use.
- **Local whisper.cpp:** download the model separately. Uses Metal on macOS
  and CPU in the Windows/Linux packages.
- **Groq or OpenAI:** send audio to the selected provider using your API key.

**Rewriting — transcript to final text**

- **Ollama:** runs locally at `http://localhost:11434`. Install Ollama, start its
  server, and download the configured model. The default is `qwen3.5:4b`.
- **Groq, OpenAI, or Anthropic:** send the transcript and rewriting instructions
  to the selected provider using your API key.

Your account determines cloud usage limits, availability, and billing. Setup
includes links to obtain the selected provider's API key.

For **fully local dictation**, choose Apple SpeechAnalyzer or local whisper.cpp
for transcription and Ollama for rewriting. Download the Ollama model first:

```bash
ollama pull qwen3.5:4b
```

If you choose whisper.cpp on macOS/Linux, download its approximately 1.5 GB
model before testing transcription:

```bash
mkdir -p "$HOME/.cache/whisper.cpp"
curl -fL --retry 3 \
  https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-large-v3-turbo.bin \
  -o "$HOME/.cache/whisper.cpp/ggml-large-v3-turbo.bin"
```

On Windows, the default location for the same model is
`%LOCALAPPDATA%\voice-prompt\whisper.cpp\ggml-large-v3-turbo.bin`.
The wizard checks for the file; it does not download it automatically.

## Updates

On **macOS arm64**, choose **Buscar actualizaciones** from the menu bar or use
the update button in Settings. An available update can be downloaded,
installed, and followed by an app restart.

On **Windows and Linux**, download and install the latest package manually.
In-app updates are not configured for those platforms yet.

The `voice-prompt.app.tar.gz` and `latest.json` release assets serve the macOS
updater. For manual macOS installation, choose the ZIP.

## Privacy and local data

- **Local transcription + Ollama:** audio and text are processed on your
  computer after the required models are installed.
- **Local transcription + cloud rewriting:** only the transcript and rewriting
  instructions, including your vocabulary, are sent to the LLM provider.
- **Cloud transcription:** audio is sent to the transcription provider;
  rewriting follows your separate provider choice.

API keys use **macOS Keychain**, **Windows Credential Manager**, or **Linux
Secret Service**, and are kept out of the preferences JSON.

Local processing still retains data on disk:

- **Preferences:** `~/.config/voice-prompt/config.json` on macOS/Linux;
  `%APPDATA%\voice-prompt\config.json` on Windows. Override with `VP_CONFIG_DIR`
  or `XDG_CONFIG_HOME`.
- **History:** original and rewritten text, provider, mode, and timings in
  `~/.local/share/voice-prompt/history.jsonl`, rotated at about 5 MiB with one
  previous file retained. Override with `VP_HISTORY_DIR` or `XDG_DATA_HOME`.
  Windows needs one of those overrides or a `HOME` variable for history to
  be available.
- **Debug recording:** the graphical app attempts to overwrite
  `/tmp/voice-prompt-last.wav` with the latest audio, even if it is later
  discarded as silence.
- **macOS logs:** `~/Library/Logs/voice-prompt.log` includes original and
  rewritten dictation text as well as diagnostics.

## Troubleshooting

**macOS blocks the first launch**

After attempting to open the app, go to **System Settings → Privacy & Security**
and use **Open Anyway** for voice-prompt if available. Apple's
[guide to opening apps from outside the App Store](https://support.apple.com/en-us/102445)
explains the process. The Terminal installer above clears quarantine as part
of installation.

**The app opens, but I cannot find its window**

On macOS, look in the menu bar and choose **Ajustes…**. There is normally no
Dock icon. If `open -a voice-prompt` cannot locate a freshly installed copy,
open `/Applications/voice-prompt.app` directly in Finder.

**The hotkey or automatic paste does not work**

On macOS, enable voice-prompt under **System Settings → Privacy & Security →
Accessibility**, then reopen the app. On Linux, confirm you are in an X11
session. Windows/Linux automatic paste remains experimental as described above.

**Recording is silent, or a provider fails**

Check microphone access and test the selected provider again in Settings.
The Windows permission indicator does not verify the system microphone setting.
Check that a local Whisper download completed, that Ollama is running with
the selected model, or that your cloud API key and account limits allow requests.

**Run diagnostics on macOS**

Choose **Comprobar todo** from the menu bar, or run:

```bash
/Applications/voice-prompt.app/Contents/MacOS/voice-prompt --doctor
```

Diagnostics can access the microphone and make a test rewriting request to
your configured provider. If automatic paste fails after writing to the
clipboard, you can paste the result manually.
