#!/usr/bin/env bash

set -euo pipefail

# Require a project name.
if [[ $# -ne 1 ]]; then
    echo "Usage: cpp-new <project-name>"
    exit 1
fi

PROJECT_NAME="$1"
PROJECT_ROOT="$HOME/Development"
PROJECT_PATH="$PROJECT_ROOT/$PROJECT_NAME"

# Only accept simple, safe project names.
if [[ ! "$PROJECT_NAME" =~ ^[a-zA-Z][a-zA-Z0-9_-]*$ ]]; then
    echo "Error: Invalid project name."
    exit 1
fi

# Require a project name.
if [[ $# -ne 1 ]]; then
    echo "Usage: cpp-new <project-name>"
    exit 1
fi

# Never overwrite an existing project.
if [[ -e "$PROJECT_PATH" ]]; then
    echo "Error: Project already exists."
    exit 1
fi

echo "Creating project: $PROJECT_NAME"

# Create our project directories.
mkdir -p "$PROJECT_PATH"/{src,include,tests,docs,scripts}

# Create starter configuration files.

# Locate templates relative to the script itself.
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/templates"

# Generate CMakeLists.txt with the project name.
sed "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
    "$TEMPLATE_DIR/CMakeLists.txt" \
    > "$PROJECT_PATH/CMakeLists.txt"

# Copy the starter application.
cp "$TEMPLATE_DIR/src/main.cpp" \
    "$PROJECT_PATH/src/main.cpp"

# Copy over Presets
cp "$TEMPLATE_DIR/CMakePresets.json" \
    "$PROJECT_PATH/CMakePresets.json"


# Copy shared configuration files.
cp "$TEMPLATE_DIR/.clang-format" \
    "$PROJECT_PATH/.clang-format"

cp "$TEMPLATE_DIR/.gitignore" \
    "$PROJECT_PATH/.gitignore"

# Generate project-specific documentation.
sed "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
    "$TEMPLATE_DIR/README.md" \
    > "$PROJECT_PATH/README.md"

# Initialize version control
cd "$PROJECT_PATH"

git init -b main
git add .

git commit -m "chore: initialize C++ project"

echo "Project created at: $PROJECT_PATH"
