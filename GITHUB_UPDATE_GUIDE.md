# ALPINE GitHub Repository Update Guide

This guide will help you update your forked GitHub repository `dokes288/ALPINE` with all the optimized files and folders for ALPINE simulation.

## Overview

The ALPINE repository has been completely optimized with:
- **Python 3.10+**: All Python scripts updated to modern Python syntax
- **C++17**: Full C++17 standard support with modern features
- **C17**: C17 standard for C code
- **GCC 11**: Optimized compiler toolchain
- **Ubuntu 22.04**: Complete compatibility with Ubuntu 22.04 LTS
- **Modern Shell**: Updated bash scripts with modern standards

## Prerequisites

Before updating your GitHub repository, ensure you have:

1. **Git installed** and configured
2. **GitHub account** with access to `dokes288/ALPINE`
3. **SSH key** or **personal access token** for GitHub authentication
4. **Local repository** with all the optimized files

## Update Methods

### Method 1: Automated Update (Recommended)

#### For Windows (PowerShell):
```powershell
# Navigate to ALPINE directory
cd "C:\Users\dokek\gem5-X\ALPINE"

# Run the PowerShell update script
.\update_github_repo.ps1

# Or with custom options
.\update_github_repo.ps1 -CommitMessage "Custom commit message" -CreateRelease
```

#### For Linux/macOS (Bash):
```bash
# Navigate to ALPINE directory
cd /path/to/ALPINE

# Make script executable
chmod +x update_github_repo.sh

# Run the bash update script
./update_github_repo.sh
```

### Method 2: Manual Update

#### Step 1: Check Repository Status
```bash
# Check current status
git status

# Check remote configuration
git remote -v
```

#### Step 2: Stage All Changes
```bash
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
```

#### Step 3: Commit Changes
```bash
# Commit with descriptive message
git commit -m "Update ALPINE simulation with Python 3.10+, C++17, C17, GCC 11, and Ubuntu 22.04 compatibility" \
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
```

#### Step 4: Push to GitHub
```bash
# Push to master branch
git push origin master

# Or push to a specific branch
git push origin your-branch-name
```

#### Step 5: Create Release (Optional)
```bash
# Create a tag
git tag -a "v2024.01.15-ubuntu22-optimized" -m "ALPINE Simulation v2024.01.15 - Ubuntu 22.04 Optimized"

# Push the tag
git push origin "v2024.01.15-ubuntu22-optimized"
```

## Files and Folders to Update

### Modified Files
- `aimclib/` - Updated C++17 library
- `gem5-X-ALPINE/` - Updated gem5 with Ubuntu 22.04 compatibility
- All Python scripts updated to Python 3.10+
- All shell scripts updated to modern bash standards

### New Files
- `aimclib_python3/` - Python 3.10+ equivalent of aimclib
- `*.md` - Comprehensive documentation
- `*.sh` - Setup and build scripts
- `*.py` - Python utilities and tools
- `*.txt` - Requirements and configuration files

### Updated .gitignore
The `.gitignore` file has been updated to include:
- Build artifacts
- Python cache files
- IDE files
- OS-specific files
- Log files
- Temporary files
- ALPINE-specific files

## Verification

After updating your repository, verify the update by:

1. **Check GitHub repository**: Visit https://github.com/dokes288/ALPINE
2. **Verify files**: Ensure all files are present and updated
3. **Check commits**: Review the commit history
4. **Test builds**: Run the build scripts to ensure everything works

## Troubleshooting

### Common Issues

#### 1. Authentication Issues
```bash
# Check SSH key
ssh -T git@github.com

# Or use HTTPS with token
git remote set-url origin https://github.com/dokes288/ALPINE.git
```

#### 2. Merge Conflicts
```bash
# Pull latest changes
git pull origin master

# Resolve conflicts
git add .
git commit -m "Resolve merge conflicts"
```

#### 3. Large File Issues
```bash
# Check file sizes
git ls-files | xargs ls -la | sort -k5 -rn | head

# Use Git LFS for large files
git lfs track "*.bin"
git lfs track "*.img"
```

#### 4. Permission Issues
```bash
# Check repository permissions
git remote get-url origin

# Update remote URL if needed
git remote set-url origin https://github.com/dokes288/ALPINE.git
```

## Post-Update Steps

After successfully updating your GitHub repository:

1. **Update README**: Ensure the main README reflects the new features
2. **Create Issues**: Document any known issues or limitations
3. **Enable Actions**: Set up GitHub Actions for CI/CD if needed
4. **Update Wiki**: Update the repository wiki with new information
5. **Notify Contributors**: Inform other contributors about the updates

## Repository Structure

After the update, your repository should have this structure:

```
ALPINE/
├── aimclib/                    # C++17 library
├── aimclib_python3/           # Python 3.10+ library
├── gem5-X-ALPINE/             # Updated gem5 simulator
├── full_system_images/        # System images (if applicable)
├── docs/                      # Documentation
├── scripts/                   # Build and setup scripts
├── tests/                     # Test files
├── .gitignore                 # Updated gitignore
├── README.md                  # Main README
├── LICENSE                    # License file
└── update_github_repo.*       # Update scripts
```

## Support

If you encounter any issues during the update process:

1. Check the troubleshooting section above
2. Review the git logs: `git log --oneline`
3. Check the repository status: `git status`
4. Contact the maintainers for assistance

## Conclusion

This guide provides comprehensive instructions for updating your ALPINE GitHub repository with all the optimized files and folders. The automated scripts make the process straightforward, while the manual method gives you full control over the update process.

Your updated repository will be fully optimized for ALPINE simulation with modern programming language standards and Ubuntu 22.04 compatibility.
