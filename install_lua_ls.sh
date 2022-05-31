INSTALLATION_DIR="$APPDATA\lua-language-server"
ALIAS_PATH="$ProgramData/chocolatey/bin/lua-language-server"

URL=$(curl -L -s "https://api.github.com/repos/sumneko/lua-language-server/releases/latest" | \
    grep -o -E "https://.*/lua-language-server-.*-win32-x64\.zip")

echo "Install version: $URL"
echo ""

TEMP_FILE="$TEMP/lua-ls.zip"

curl -L -s "$URL" > "$TEMP_FILE"
rm -rf $INSTALLATION_DIR
unzip -q "$TEMP_FILE" -d "$INSTALLATION_DIR"
rm "$TEMP_FILE"

echo '#!/bin/bash' > "$ALIAS_PATH"
echo "exec \"$INSTALLATION_DIR/bin/lua-language-server\" \"\$@\"" >> "$ALIAS_PATH"