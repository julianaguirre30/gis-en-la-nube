#!/bin/bash
# Abre la presentación desde un servidor local para que los videos de YouTube
# se reproduzcan solos dentro de cada filmina (YouTube los bloquea si el HTML
# se abre con doble clic como archivo).
cd "$(dirname "$0")" || exit 1
PORT=8765
FILE="GIS_en_la_Nube_Grupo10.html"
URL="http://localhost:$PORT/$FILE"

# Si ya hay un servidor en ese puerto, se reutiliza
if ! curl -s -o /dev/null "http://localhost:$PORT/$FILE"; then
  if command -v python3 >/dev/null 2>&1; then
    python3 -m http.server "$PORT" --bind 127.0.0.1 >/dev/null 2>&1 &
  elif command -v ruby >/dev/null 2>&1; then
    ruby -run -e httpd . -p "$PORT" -b 127.0.0.1 >/dev/null 2>&1 &
  else
    osascript -e 'display alert "No se encontró Python" message "Instalá las herramientas de desarrollo con: xcode-select --install"'
    exit 1
  fi
  SERVER=$!
  for i in $(seq 1 30); do curl -s -o /dev/null "$URL" && break; sleep 0.2; done
fi

if [ -d "/Applications/Google Chrome.app" ]; then
  open -a "Google Chrome" "$URL"
else
  open "$URL"
fi

echo ""
echo "  Presentación abierta en: $URL"
echo "  Dejá esta ventana abierta mientras exponen. Al terminar, cerrala."
echo ""
[ -n "$SERVER" ] && wait "$SERVER"
