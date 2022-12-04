#!/usr/bin/env bash
set -e
echo "Copying dylib..."
DYLIB_PATH=./LookinLoaderPrefs/layout/Library/Application\ Support/LookinLoader
if [ ! -d "$DYLIB_PATH" ]; then
	mkdir -p $DYLIB_PATH
	echo '创建DYLIB_PATH'
fi

echo "===================================="

echo "##WARNING: resign LookinServer.framework"
codesign -fs "Apple Development: Qianduan Da (4V52F2MX45)" "$DYLIB_PATH"/LookinServer.framework
echo "===================================="

echo "Done."
