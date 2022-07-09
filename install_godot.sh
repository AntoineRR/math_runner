GODOT_VERSION=3.4.4

GODOT_BIN=Godot_v${GODOT_VERSION}-stable_linux_headless.64
GODOT_URL=https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/${GODOT_BIN}.zip

curl ${GODOT_URL} --output ${GODOT_BIN}.zip
unzip ${GODOT_BIN}.zip
chmod +x ${GODOT_BIN}
mv ${GODOT_BIN} /usr/local/bin/godot