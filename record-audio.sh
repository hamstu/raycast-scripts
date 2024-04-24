#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Record Audio to Downloads
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🎙️

# Documentation:
# @raycast.description Records ssytem audio using `sox` CLI and saves it to Downloads folder.
# @raycast.author hamstu
# @raycast.authorURL https://github.com/hamstu

#!/bin/bash

# Define the PID file and output directory
PIDFILE="$HOME/recording.pid"
OUTPUT_DIR="$HOME/Downloads"
DATE=$(date +%Y-%m-%d-%H%M%S)
TEMPFILE="/tmp/recording.mp3"

set_to_multioutput_audio_device() {
  CURRENT_AUDIO_DEVICE=$(SwitchAudioSource -t output -c)
  if [[ $CURRENT_AUDIO_DEVICE == *"Multi-Output Device"* ]]; then
    return
  fi
  # otherwise, set to multi-output device
  OUTPUT_DEVICES=$(SwitchAudioSource -a | grep "Multi-Output Device")
  FIRST_DEVICE=$(echo "$OUTPUT_DEVICES" | head -n 1 | awk '{print $0}')
  AUDIO_DEVICE=$FIRST_DEVICE
  if [[ $CURRENT_AUDIO_DEVICE == *"headphones"* ]]; then
    AUDIO_DEVICE=$(echo "$OUTPUT_DEVICES" | grep -i "headphones" | awk '{print $0}')
    if [ -z "$AUDIO_DEVICE" ]; then
      AUDIO_DEVICE=$FIRST_DEVICE
    fi
  fi
  SwitchAudioSource -s "$AUDIO_DEVICE" >/dev/null 2>&1
}

save_initial_audio_devices_to_file() {
  INITIAL_OUTPUT_DEVICE=$(SwitchAudioSource -t output -c)
  INITIAL_SYSTEM_DEVICE=$(SwitchAudioSource -t system -c)

  # write to tmp file
  echo "$INITIAL_OUTPUT_DEVICE" >"/tmp/initial_output_device"
  echo "$INITIAL_SYSTEM_DEVICE" >"/tmp/initial_system_device"
}

reset_to_initial_audio_device() {
  # read from tmp file
  INITIAL_OUTPUT_DEVICE=$(cat "/tmp/initial_output_device")
  INITIAL_SYSTEM_DEVICE=$(cat "/tmp/initial_system_device")

  SwitchAudioSource -t output -s "$INITIAL_OUTPUT_DEVICE" >/dev/null 2>&1
  SwitchAudioSource -t system -s "$INITIAL_SYSTEM_DEVICE" >/dev/null 2>&1
}

# Function to start recording
start_recording() {
  save_initial_audio_devices_to_file
  set_to_multioutput_audio_device
  # Start recording to temp file
  sox -t coreaudio "BlackHole 2ch" -C 192.2 "$TEMPFILE" -V0 >/dev/null 2>&1 &
  PID=$!
  echo $PID >"$PIDFILE"
  echo "🎬 Recording Started"
}

# Check if the PID file exists
if [ -f "$PIDFILE" ]; then
  PID=$(cat "$PIDFILE")
  # Check if the process is still running
  if ps -p "$PID" >/dev/null; then
    # echo "Stopping recording with PID $PID..."
    kill -INT "$PID"
    rm "$PIDFILE"

    # Remove silence from the beginning and end of the recording then output to
    # the final file
    FILENAME="recording_$DATE.mp3"
    FINAL_OUTPUT_FILE="$OUTPUT_DIR/$FILENAME"
    sox "$TEMPFILE" "$FINAL_OUTPUT_FILE" silence 1 0.1 0% reverse silence 1 0.1 0% reverse
    # copy filename to clipboard
    echo "$FILENAME" | pbcopy
    reset_to_initial_audio_device
    afplay /System/Library/Sounds/Blow.aiff >/dev/null 2>&1 &

    echo "✅ Recording Complete"
  else
    # echo "No recording process running. Cleaning up PID file."
    rm "$PIDFILE"
    start_recording
  fi
else
  start_recording
fi
