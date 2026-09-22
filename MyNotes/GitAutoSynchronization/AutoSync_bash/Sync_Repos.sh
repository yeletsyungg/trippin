#!/bin/bash

# ==============================================================================
# CONFIGURATION
# ==============================================================================
# Specify absolute paths to repositories
SOURCE_DIR="C:\Users\user\Documents\Repositories\mfua"
DEST_DIR="C:\Users\user\Documents\Repositories\reallymatters-learning"

# Git settings for destination repository
DO_PUSH=true                             # true - do push, false - local copy only
COMMIT_MESSAGE="Updated, with auto-sync(bash)"   # Commit message

# ==============================================================================
# FUNCTIONS AND LOGIC
# ==============================================================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Pause at the end for visual control
pause_exit() {
    echo ""
    read -p "Press Enter to exit..."
    exit $1
}

# 1. Check paths
log_info "Checking paths..."
if [ ! -d "$SOURCE_DIR" ]; then
    log_error "Source directory not found: $SOURCE_DIR"
    pause_exit 1
fi
if [ ! -d "$SOURCE_DIR/.git" ]; then
    log_error "Source directory is not a Git repository (no .git)"
    pause_exit 1
fi
if [ ! -d "$DEST_DIR" ]; then
    log_error "Destination directory not found: $DEST_DIR"
    pause_exit 1
fi
if [ ! -d "$DEST_DIR/.git" ]; then
    log_error "Destination directory is not a Git repository (no .git)"
    pause_exit 1
fi

# 2. Update source repository
log_info "Executing git pull in source: $SOURCE_DIR"
cd "$SOURCE_DIR" || { log_error "Cannot change to source directory"; pause_exit 1; }
git pull
if [ $? -ne 0 ]; then
    log_warn "git pull in source completed with warnings or errors. Continuing..."
fi

# 3. Sync files (excluding .git)
log_info "Copying files from source to destination (excluding .git)..."
if command -v rsync &> /dev/null; then
    rsync -av --exclude='.git' --exclude='.gitignore' "$SOURCE_DIR/" "$DEST_DIR/"
    if [ $? -ne 0 ]; then
        log_error "Error copying files (rsync)"
        pause_exit 1
    fi
else
    log_warn "rsync not found. Using cp (less reliable for sync)"
    find "$SOURCE_DIR" -mindepth 1 -maxdepth 1 -not -name '.git' -exec cp -rf {} "$DEST_DIR/" \;
fi

# 4. Update destination repository (Optional)
if [ "$DO_PUSH" = true ]; then
    log_info "Updating destination repository: $DEST_DIR"
    cd "$DEST_DIR" || { log_error "Cannot change to destination directory"; pause_exit 1; }

    git status --porcelain
    if [ $? -eq 0 ]; then
        changes=$(git status --porcelain)
        if [ -n "$changes" ]; then
            git add .
            git commit -m "$COMMIT_MESSAGE"
            if [ $? -eq 0 ]; then
                log_info "Executing git push..."
                git push
                if [ $? -ne 0 ]; then
                    log_error "git push failed. Check access rights or remote changes."
                else
                    log_info "Push successful!"
                fi
            else
                log_warn "Nothing to commit or commit error."
            fi
        else
            log_info "No changes detected, commit not required."
        fi
    fi
else
    log_info "DO_PUSH=false. Skipping commit/push in destination."
fi

log_info "Synchronization completed."
pause_exit 0