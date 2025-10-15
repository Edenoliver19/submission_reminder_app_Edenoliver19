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
