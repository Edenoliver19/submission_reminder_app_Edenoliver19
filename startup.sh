#!/bin/bash
ROOT="$(cd "$(dirname "$0")" && pwd)"
find "$ROOT" -type f -name '*.sh' -exec chmod +x {} \;
echo "Launching Submission Reminder App at $(date)..."
"$ROOT/scripts/notify.sh"
