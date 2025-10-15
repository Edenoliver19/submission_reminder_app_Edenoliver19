Submission Reminder App

This shell-based application helps track students’ assignment submissions. It can notify which students have not submitted a particular assignment and allows updating the assignment name easily using the copilot script.

Repository Contents

This repository contains only three files, as required:

create_environment.sh – Sets up the application environment and creates the necessary directories and sample files.

copilot_shell_script.sh – Updates the assignment name in config/config.env.

README.md – This instruction file.

How to Use
1. Make the scripts executable
chmod +x create_environment.sh copilot_shell_script.sh

2. Run the environment setup
./create_environment.sh


Follow the prompt to enter your name.

This will create a folder submission_reminder_{YourName} containing all app files.

The script automatically runs startup.sh once to test the app.

3. Navigate to your app folder
cd submission_reminder_{YourName}

4. Update the assignment name (optional)
../copilot_shell_script.sh


Enter the new assignment name when prompted.

This updates config/config.env so startup.sh will check the correct assignment.

5. Start the reminder app
./startup.sh


This runs the reminder system and prints which students have not submitted the current assignment.

It also ensures all .sh scripts in the app folder are executable.

Notes

create_environment.sh seeds records/submissions.csv with at least 10 sample student records for testing.

All scripts handle errors gracefully (e.g., empty input, missing files).

The application structure is modular:

scripts/notify.sh → main reminder script

helpers/functions.sh → helper functions

records/submissions.csv → student submission data

media/image.png → placeholder image

License

MIT
