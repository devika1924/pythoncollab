#!/bin/bash

# Automatically set the repository directory
REPO_DIR="C:/Users/91721/Documents/python-prac3"  # Update this path to your repository
LOG_FILE="$REPO_DIR/version_history.log"

# Debugging: Print the repository directory
echo "Repository Directory: $REPO_DIR"

# Change to the repository directory
cd "$REPO_DIR" || { echo "Repository not found!"; exit 1; }

# Confirm we're in the right directory
echo "Successfully changed to repository directory."

# Check if it's already a Git repository, if not, initialize it
if [ ! -d ".git" ]; then
    echo "Initializing Git repository..."
    git init || { echo "Failed to initialize Git repository."; exit 1; }
    echo "Git repository initialized."
else
    echo "Git repository already initialized."
fi

# Find .py, .yaml, and .json files in the repository
FILES=$(find "$REPO_DIR" -type f \( -iname "*.py" -o -iname "*.yaml" -o -iname "*.json" \))

# If no files found, exit
if [ -z "$FILES" ]; then
    echo "No Python, YAML, or JSON files found in the repository."
    exit 1
fi

# Automatically add all the files to the git repository
echo "Adding all files to the Git repository..."
git add . || { echo "Error adding files."; exit 1; }

# Ask for a commit message (optional, you can automate it)
read -p "Enter commit message: " COMMIT_MESSAGE
if [ -z "$COMMIT_MESSAGE" ]; then
    CURRENT_DATE=$(date +"%Y-%m-%d %H:%M:%S")
    COMMIT_MESSAGE="Commit on $CURRENT_DATE"
fi

# Commit the changes
git commit -m "$COMMIT_MESSAGE" || { echo "Commit failed."; exit 1; }
echo "Commit successful."

# Log the commit details
COMMIT_HASH=$(git log -1 --format=%h)
echo "$CURRENT_DATE - $COMMIT_MESSAGE - Commit Hash: $COMMIT_HASH" >> "$LOG_FILE" || { echo "Failed to write to log file."; exit 1; }

# Check if GitHub remote is set; if not, ask the user for the GitHub repository URL
REMOTE_URL=$(git remote get-url origin 2>/dev/null)
if [ -z "$REMOTE_URL" ]; then
    echo "No remote repository found. Please enter the GitHub repository URL:"
    read -p "GitHub Repository URL (e.g., https://github.com/username/repository.git): " GITHUB_URL
    git remote add origin "$GITHUB_URL" || { echo "Failed to add remote repository."; exit 1; }
    echo "Remote repository added: $GITHUB_URL"
else
    echo "Remote repository already set: $REMOTE_URL"
fi

# Push the changes to GitHub
git push -u origin master || { echo "Failed to push changes to GitHub."; exit 1; }

# Success message
echo "Changes pushed to GitHub successfully!"

# Show the git status
git status
