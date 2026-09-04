#!/usr/bin/env bash
# Instala voice-prompt desde el último Release de GitHub.
#
#   curl -fsSL https://raw.githubusercontent.com/RemLiquit/voice-prompt-releases/main/install.sh | sh
#
# Este script vive DUPLICADO a propósito: aquí (fuente, privada) para que
# quede versionado junto al workflow que lo generó, y en
# RemLiquit/voice-prompt-releases (público) que es desde donde de verdad se
# hace curl — un repo privado no sirve raw.githubusercontent.com sin token.
# Si lo tocas, cópialo también al otro repo.
#
# Descarga el .zip del último Release, lo instala en /Applications y le
# quita el atributo de cuarentena de macOS (com.apple.quarantine) para que
# abra sin el aviso de Gatekeeper "no se puede verificar el desarrollador".
# Esto no es un rodeo oculto, es justo lo que hace este paso a la vista: solo
# tiene efecto porque estás ejecutando tú mismo este instalador. La app no
# está firmada con un certificado de Developer ID de pago (ver README), así
# que sin este paso tocaría hacer clic derecho → Abrir a mano la primera vez.
set -euo pipefail

REPO="RemLiquit/voice-prompt-releases"
APP_NAME="voice-prompt.app"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "voice-prompt es solo para macOS." >&2
  exit 1
fi

if [[ "$(uname -m)" != "arm64" ]]; then
  echo "Por ahora solo se publica build para Apple Silicon (arm64)." >&2
  exit 1
fi

echo "› Buscando el último release…"
api="https://api.github.com/repos/${REPO}/releases/latest"
body="$(curl -fsSL "$api")"
tag="$(printf '%s' "$body" | grep -o '"tag_name": *"[^"]*"' | head -1 | cut -d'"' -f4)"
asset_url="$(printf '%s' "$body" | grep -o '"browser_download_url": *"[^"]*\.zip"' | head -1 | cut -d'"' -f4)"

if [[ -z "$asset_url" ]]; then
  echo "No encontré ningún .zip en el último release de ${REPO}." >&2
  echo "Si el repo es privado, este instalador público no puede acceder a él." >&2
  exit 1
fi
echo "› Versión ${tag:-desconocida}"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

echo "› Descargando…"
curl -fsSL "$asset_url" -o "$tmp/voice-prompt.zip"

echo "› Extrayendo…"
ditto -x -k "$tmp/voice-prompt.zip" "$tmp"

if [[ ! -d "$tmp/$APP_NAME" ]]; then
  echo "El zip descargado no contiene ${APP_NAME}." >&2
  exit 1
fi

if pgrep -x voice-prompt >/dev/null 2>&1; then
  echo "› Cerrando voice-prompt (estaba abierto)…"
  pkill -x voice-prompt || true
  sleep 1
fi

echo "› Instalando en /Applications…"
rm -rf "/Applications/${APP_NAME}"
cp -R "$tmp/$APP_NAME" /Applications/

echo "› Quitando la cuarentena de Gatekeeper…"
xattr -cr "/Applications/${APP_NAME}"

echo
echo "Listo — voice-prompt ${tag:-} instalado."
echo "Ábrela con: open -a voice-prompt"
echo "Vive en la barra de menús, no en el Dock. La primera vez te pedirá permiso de micrófono y accesibilidad."
