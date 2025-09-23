#!/bin/bash
# ALPINE GitHub Repository Update Script
# This script updates the dokes288/ALPINE repository with all optimized files

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Configuration
readonly REPO_NAME="ALPINE"
readonly GITHUB_USER="dokes288"
readonly GITHUB_REPO="dokes288/ALPINE"
readonly BRANCH="master"
readonly COMMIT_MESSAGE="Update ALPINE simulation with Python 3.10+, C++17, C17, GCC 11, and Ubuntu 22.04 compatibility"

# Check if we're in a git repository
check_git_repo() {
    log_info "Checking git repository status..."
    
    if [[ ! -d ".git" ]]; then
        log_error "Not in a git repository. Please run this script from the ALPINE root directory."
        exit 1
    fi
    
    # Check if remote origin is set
    if ! git remote get-url origin &>/dev/null; then
        log_warning "No remote origin found. Setting up GitHub remote..."
        git remote add origin "https://github.com/${GITHUB_REPO}.git"
    fi
    
    log_success "Git repository status verified"
}

# Create/update .gitignore
update_gitignore() {
    log_info "Updating .gitignore for ALPINE simulation..."
    
    cat > .gitignore << 'EOF'
# ALPINE Simulation .gitignore
# Generated for optimized ALPINE simulation repository

# Build artifacts
build/
m5out/
*.o
*.so
*.a
*.dylib
*.dll
*.exe

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
venv/
ENV/
env.bak/
venv.bak/
*.egg-info/
dist/
build/

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Logs
*.log
logs/
m5out/

# Temporary files
*.tmp
*.temp
*.bak
*.backup

# SCons
.sconsign.dblite
.sconsign.dblite.dblite

# gem5 specific
m5out/
*.cpt
*.cpt.*
*.checkpoint
*.checkpoint.*

# ALPINE specific
aimclib_python3/__pycache__/
*.pyc
*.pyo

# Full system images
full_system_images/binaries/
full_system_images/disks/
full_system_images/*.log

# Documentation build
docs/_build/
docs/build/

# Test outputs
test_outputs/
simulation_results/

# Backup files
*.orig
*.rej
EOF
    
    log_success ".gitignore updated"
}

# Stage all changes
stage_changes() {
    log_info "Staging all changes..."
    
    # Add all modified files
    git add aimclib/
    git add gem5-X-ALPINE/
    git add .gitignore
    
    # Add new files
    git add aimclib_python3/
    git add "*.md"
    git add "*.sh"
    git add "*.py"
    git add "*.txt"
    
    log_success "All changes staged"
}

# Commit changes
commit_changes() {
    log_info "Committing changes..."
    
    git commit -m "$COMMIT_MESSAGE" \
        -m "This commit includes:" \
        -m "- Updated aimclib with C++17 and modern C++ features" \
        -m "- Added Python 3.10+ equivalent of aimclib" \
        -m "- Updated gem5-X-ALPINE for Ubuntu 22.04 compatibility" \
        -m "- Updated all Python scripts to Python 3.10+ syntax" \
        -m "- Added C++17 and C17 standard support" \
        -m "- Updated build system for GCC 11" \
        -m "- Added comprehensive Ubuntu 22.04 setup scripts" \
        -m "- Updated shell scripts with modern bash standards" \
        -m "- Added cross-compilation support" \
        -m "- Enhanced documentation and README files" \
        -m "- Optimized for ALPINE simulation performance"
    
    log_success "Changes committed"
}

# Push to GitHub
push_to_github() {
    log_info "Pushing changes to GitHub..."
    
    # Push to master branch
    git push origin "$BRANCH"
    
    log_success "Changes pushed to GitHub"
}

# Create release
create_release() {
    log_info "Creating GitHub release..."
    
    # Get current version
    local version=$(date +"%Y.%m.%d")
    local tag="v${version}-ubuntu22-optimized"
    
    # Create tag
    git tag -a "$tag" -m "ALPINE Simulation v${version} - Ubuntu 22.04 Optimized"
    git push origin "$tag"
    
    log_success "Release created: $tag"
}

# Verify repository
verify_repository() {
    log_info "Verifying repository status..."
    
    # Check git status
    git status --porcelain
    
    # Check remote
    git remote -v
    
    # Check branches
    git branch -a
    
    log_success "Repository verification completed"
}

# Main function
main() {
    log_info "Starting ALPINE GitHub Repository Update"
    log_info "========================================"
    
    # Check git repository
    check_git_repo
    
    # Update .gitignore
    update_gitignore
    
    # Stage changes
    stage_changes
    
    # Commit changes
    commit_changes
    
    # Push to GitHub
    push_to_github
    
    # Create release
    create_release
    
    # Verify repository
    verify_repository
    
    log_success "ALPINE GitHub Repository Update completed successfully!"
    log_info "========================================"
    log_info "Repository: https://github.com/${GITHUB_REPO}"
    log_info "Branch: ${BRANCH}"
    log_info "Latest commit: $(git rev-parse HEAD)"
    log_info "========================================"
}

# Run main function
main "$@"
