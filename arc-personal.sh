#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Arc Personal
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🙆🏻‍♂️
# @raycast.packageName Arc

# Documentation:
# @raycast.description Open Arc Personal space
# @raycast.author hamstu
# @raycast.authorURL https://raycast.com/hamstu

# Run AppleScript command
osascript <<EOF
tell application "Arc"
    tell front window
        tell space "Personal" to focus
    end tell
    activate
end tell
EOF
