#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Arc Sherwood Shelving
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🪜
# @raycast.packageName Arc

# Documentation:
# @raycast.description Open Arc Sherwood Shelving space
# @raycast.author hamstu
# @raycast.authorURL https://raycast.com/hamstu

# Run AppleScript command
osascript <<EOF
tell application "Arc"
    tell front window
        tell space "Sherwood Shelving" to focus
    end tell
    activate
end tell
EOF
