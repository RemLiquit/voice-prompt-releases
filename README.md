# voice-prompt

Dictado por voz local para macOS: mantienes una tecla, hablas, sueltas, y el
texto transcrito y reescrito aparece donde tengas el cursor.

Este repositorio solo distribuye **binarios compilados** (Releases). El
código fuente es privado.

## Instalar

```
curl -fsSL https://raw.githubusercontent.com/RemLiquit/voice-prompt-releases/main/install.sh | sh
```

Descarga el último release, lo instala en `/Applications` y le quita el
atributo de cuarentena de macOS para que abra sin el aviso de Gatekeeper (la
app no está firmada con un certificado de Developer ID de pago).

Requisitos: macOS en Apple Silicon (arm64).

## Instalación manual

Descarga el `.zip` desde [Releases](https://github.com/RemLiquit/voice-prompt-releases/releases),
descomprímelo y arrastra `voice-prompt.app` a `/Applications`. La primera vez
tendrás que hacer clic derecho → Abrir para saltar el aviso de Gatekeeper.

## Licencia

© 2026 Diego (RemLiquit). Todos los derechos reservados. Estos binarios se
distribuyen para su uso, no para su redistribución ni modificación. El
código fuente no es público.
