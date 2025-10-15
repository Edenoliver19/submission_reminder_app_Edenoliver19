#!/bin/bash

set -euo pipefail

read -p "Enter your name (used for environment folder): " CREATOR_NAME
[[ -z "$CREATOR_NAME" ]] && { echo "Name cannot be empty. Exiting."; exit 1; }

ENV_DIR="submission_reminder_${CREATOR_NAME}"
if [[ -d "$ENV_DIR" ]]; then
    echo "Directory '$ENV_DIR' already exists. Aborting."
    exit 1
fi

mkdir -p "$ENV_DIR"/{scripts,helpers,config,records,media}

echo "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR4nGNgYAAAAAMAASsJTYQAAAAASUVORK5CYII=" \
  | base64 -d > "$ENV_DIR/media/image.png"

cat > "$ENV_DIR/config/config.env" <<'CFG'
# App configuration
ASSIGNMENT="Shell Basics"
DAYS_REMAINING=3
CFG

cat > "$ENV_DIR/helpers/functions.sh" <<'FUN'
#!/bin/bash
remind_students() {
    local file="$1"
    local assignment="${2:-$ASSIGNMENT}"
    tail -n +2 "$file" | while IFS=, read -r student asg status; do
        student=$(echo "$student" | xargs)
        asg=$(echo "$asg" | xargs)
        status=$(echo "$status" | xargs)
        if [[ "$asg" == "$assignment" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $assignment assignment."
        fi
    done
}
list_students() {
    local file="$1"
    tail -n +2 "$file" | cut -d, -f1 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | sort -u
}
FUN

cat > "$ENV_DIR/scripts/notify.sh" <<'REM'
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
REM

cat > "$ENV_DIR/records/submissions.csv" <<'SUB'
student,assignment,status
Alice,Shell Basics,not submitted
Brian,Git,submitted
Clare,Shell Basics,submitted
Diane,Shell Basics,not submitted
Ethan,Shell Basics,submitted
Fatima,Shell Basics,not submitted
George,Shell Basics,not submitted
Hannah,Git,not submitted
# Extra students
Ivy,Shell Basics,not submitted
Jack,Shell Basics,submitted
Kate,Shell Basics,not submitted
Leo,Shell Basics,not submitted
Mia,Shell Basics,submitted
SUB

cat > "$ENV_DIR/startup.sh" <<'ST'
#!/bin/bash
ROOT="$(cd "$(dirname "$0")" && pwd)"
find "$ROOT" -type f -name '*.sh' -exec chmod +x {} \;
echo "Launching Submission Reminder App at $(date)..."
"$ROOT/scripts/notify.sh"
ST

find "$ENV_DIR" -type f -name "*.sh" -exec chmod +x {} \;

echo
echo "✅ Environment created successfully: $ENV_DIR"
echo "To test, run:"
echo "  cd $ENV_DIR && ./startup.sh"
