#!/bin/bash
set -e

# Setup directories
APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="$APP_DIR/audio_app_env"
DIST_DIR="$APP_DIR/dist"

echo "=== Offline TTS App Builder ==="

# Ensure Venv exists
if [ ! -d "$VENV_DIR" ]; then
    echo "Creating virtual environment..."
    python3 -m venv "$VENV_DIR"
fi

source "$VENV_DIR/bin/activate"

# Install Building Deps
echo "Installing requirements..."
pip install -r "$APP_DIR/requirements.txt" > /dev/null

# Clean previous build
rm -rf "$APP_DIR/build" "$DIST_DIR"

# Build using PyInstaller
# --onefile: Create a single executable
# --windowed: No terminal window (GUI only)
# --name: Name of output binary
# --add-data: We might need to add TTS models manually if not auto-downloaded by the binary, 
# but Coqui usually downloads to user home. For a strictly offline 'published' app, 
# users usually include the model in the package. For now we will rely on runtime download.

echo "Building standalone executable..."
pyinstaller --clean --onefile --windowed --name "OfflineTTS" "$APP_DIR/tts_app.py" 

echo "Build Complete!"
echo "Executable located at: $DIST_DIR/OfflineTTS"
echo "You can zip the 'dist' folder and distribute it."
