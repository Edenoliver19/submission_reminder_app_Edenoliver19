#!/bin/bash
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$ROOT_DIR/config/config.env"
source "$ROOT_DIR/helpers/functions.sh"

STUDENT_FILE="$ROOT_DIR/records/submissions.csv"
CURRENT_ASSIGNMENT="${1:-$ASSIGNMENT}"

echo "Assignment: $CURRENT_ASSIGNMENT"
echo "Days remaining: $DAYS_REMAINING"
echo "---------------------------------"

remind_students "$STUDENT_FILE" "$CURRENT_ASSIGNMENT"
