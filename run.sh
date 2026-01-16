#!/bin/bash
set -e

APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="$APP_DIR/audio_app_env"

echo "=== Offline TTS App Installer & Launcher ==="

# 1. System Dependency Check
REQUIRED_PACKAGES="espeak-ng python3-tk libportaudio2"

for pkg in $REQUIRED_PACKAGES; do
    if ! dpkg -s $pkg &> /dev/null; then
        echo "Error: System package '$pkg' is missing."
        echo "Please run: sudo apt-get install $pkg"
        exit 1
    fi
done

# 2. Virtual Environment Setup
if [ ! -d "$VENV_DIR" ]; then
    echo "Creating virtual environment..."
    python3 -m venv "$VENV_DIR"
fi

source "$VENV_DIR/bin/activate"

# 3. Install Requirements
echo "Installing/Checking dependencies..."
pip install -r "$APP_DIR/requirements.txt" > /dev/null

# 4. Run App (Test or GUI)
if [ "$1" == "--test" ]; then
    echo "Running self-test..."
    python3 "$APP_DIR/tts_app.py" --test "This is a system check." --out "$APP_DIR/test_audio.wav"
else
    echo "Launching GUI..."
    python3 "$APP_DIR/tts_app.py"
fi
