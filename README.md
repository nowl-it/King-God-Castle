# KGC - King God Castle APK Extraction & Analysis Tool

A comprehensive Unix toolkit for downloading, extracting, and analyzing the "King God Castle" (킹갓캐슬) mobile game APK files. This project provides professional-grade tools for reverse engineering and examining Unity-based mobile games with extensive support for Linux, macOS, and BSD systems.

## 📱 About King God Castle

**King God Castle** is a Unity-based mobile game developed by AwesomePiece with the package name `com.awesomepiece.castle`. The game is available in multiple languages and regions, with different localized names:

- **Korean**: 킹갓캐슬
- **English**: King God Castle
- **French**: Fort KingGod
- **Japanese**: キングゴッドキャッスル
- **Chinese**: 神王城堡

## 🚀 Features

- **APK Download**: Automated APK downloading using `apkeep` from multiple sources
- **XAPK Extraction**: Extract and process split APK files (XAPK format)
- **Asset Analysis**: Deep examination of Unity game assets, scripts, and configurations with AssetRipper
- **Library Management**: Properly organize native libraries and dependencies
- **Unix Platform Support**: Works on Linux, macOS, and BSD systems
- **Unity Integration**: Full AssetRipper integration for professional asset analysis
- **Multi-language Support**: Handle localized game content and assets
- **Shell-based Workflows**: One-command extraction and analysis pipeline
- **Security Analysis**: Examine anti-cheat mechanisms and obfuscation

## 🛠️ Prerequisites & Installation

### 🐧 Linux Distributions

#### Ubuntu/Debian

```bash
# Update package lists
sudo apt update && sudo apt upgrade -y

# Install core dependencies
sudo apt install -y curl wget unzip git build-essential

# Install additional tools for analysis
sudo apt install -y python3 python3-pip nodejs npm

# Install .NET runtime for AssetRipper (if needed)
sudo apt install -y dotnet-runtime-8.0

# Clone the repository
git clone https://github.com/nowl-it/King-God-Castle.git
cd King-God-Castle

# Make scripts executable
chmod +x main.sh
```

#### Fedora/RHEL/CentOS

```bash
# Update system
sudo dnf update -y

# Install core dependencies
sudo dnf install -y curl wget unzip git gcc gcc-c++ make

# Install development tools
sudo dnf groupinstall -y "Development Tools"
sudo dnf install -y python3 python3-pip nodejs npm

# Install .NET runtime
sudo dnf install -y dotnet-runtime-8.0

# Setup project
git clone https://github.com/nowl-it/King-God-Castle.git
cd King-God-Castle
chmod +x main.sh
```

#### Arch Linux/Manjaro

```bash
# Update system
sudo pacman -Syu

# Install dependencies
sudo pacman -S curl wget unzip git base-devel python python-pip nodejs npm

# Install .NET runtime
sudo pacman -S dotnet-runtime

# AUR helper for additional tools (if using yay)
yay -S apkeep-bin

# Setup project
git clone https://github.com/nowl-it/King-God-Castle.git
cd King-God-Castle
chmod +x main.sh
```

#### openSUSE

```bash
# Update system
sudo zypper refresh && sudo zypper update

# Install dependencies
sudo zypper install -y curl wget unzip git gcc gcc-c++ make python3 python3-pip nodejs npm

# Install .NET runtime
sudo zypper install -y dotnet-runtime-8.0

# Setup project
git clone https://github.com/nowl-it/King-God-Castle.git
cd King-God-Castle
chmod +x main.sh
```

### 🍎 macOS

#### macOS 12+ (Intel/Apple Silicon)

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install dependencies
brew install curl wget unzip git python3 node dotnet

# For Apple Silicon Macs, ensure Rosetta 2 is installed
sudo softwareupdate --install-rosetta --agree-to-license

# Clone and setup
git clone https://github.com/nowl-it/King-God-Castle.git
cd King-God-Castle
chmod +x main.sh
```

## 🔧 Tool Installation

### APKeep Installation

#### Linux (All Distributions)

```bash
# Method 1: Direct installation script
curl -sSL https://raw.githubusercontent.com/EFForg/apkeep/main/install.sh | bash

# Method 2: Manual installation
wget https://github.com/EFForg/apkeep/releases/latest/download/apkeep-linux-amd64
chmod +x apkeep-linux-amd64
sudo mv apkeep-linux-amd64 /usr/local/bin/apkeep

# Method 3: Using cargo (if Rust is installed)
cargo install apkeep
```

#### macOS

```bash
# Using Homebrew
brew install apkeep

# Or manual installation
curl -L -o apkeep https://github.com/EFForg/apkeep/releases/latest/download/apkeep-macos-amd64
chmod +x apkeep
sudo mv apkeep /usr/local/bin/
```

### AssetRipper Installation

#### Linux

```bash
# Download latest release
LATEST_URL=$(curl -s https://api.github.com/repos/AssetRipper/AssetRipper/releases/latest | grep "browser_download_url.*linux.*x64" | cut -d '"' -f 4)
wget $LATEST_URL -O AssetRipper_linux.zip

# Extract and install
unzip AssetRipper_linux.zip -d assetripper/
chmod +x assetripper/AssetRipper
sudo ln -sf $(pwd)/assetripper/AssetRipper /usr/local/bin/assetripper

# Alternative: Using AppImage
wget https://github.com/AssetRipper/AssetRipper/releases/latest/download/AssetRipper.AppImage
chmod +x AssetRipper.AppImage
./AssetRipper.AppImage
```

#### macOS

```bash
# Download and install
curl -L -o AssetRipper_mac.zip https://github.com/AssetRipper/AssetRipper/releases/latest/download/AssetRipper_mac.zip
unzip AssetRipper_mac.zip -d assetripper/
chmod +x assetripper/AssetRipper
ln -sf $(pwd)/assetripper/AssetRipper /usr/local/bin/assetripper
```

#### Ubuntu/Debian and Derivatives

```bash
# Update package lists
sudo apt update && sudo apt upgrade -y

# Install essential tools
sudo apt install -y unzip curl wget build-essential git

# Install optional development tools
sudo apt install -y vim nano tree htop
```

#### Red Hat/CentOS/Fedora/Rocky Linux

```bash
# For RHEL/CentOS 8+/Rocky Linux
sudo dnf update -y
sudo dnf install -y unzip curl wget git gcc gcc-c++ make

# For older CentOS 7
# sudo yum update -y
# sudo yum install -y unzip curl wget git gcc gcc-c++ make

# For Fedora
sudo dnf update -y
sudo dnf install -y unzip curl wget git gcc gcc-c++ make
```

#### Arch Linux/Manjaro

```bash
# Update system
sudo pacman -Syu

# Install required packages
sudo pacman -S unzip curl wget git base-devel

# Install AUR helper (yay) for additional packages
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
```

#### openSUSE (Leap/Tumbleweed)

```bash
# Update system
sudo zypper refresh && sudo zypper update

# Install required packages
sudo zypper install -y unzip curl wget git gcc gcc-c++ make

# Install development patterns
sudo zypper install -t pattern devel_basis
```

#### Alpine Linux

```bash
# Update package index
sudo apk update && sudo apk upgrade

# Install required packages
sudo apk add unzip curl wget git build-base bash

# Install additional tools
sudo apk add vim nano tree htop
```

#### Gentoo Linux

```bash
# Update portage tree
sudo emerge --sync

# Install required packages
sudo emerge -av app-arch/unzip net-misc/curl net-misc/wget dev-vcs/git

# Install development tools
sudo emerge -av sys-devel/gcc sys-devel/make
```

#### NixOS

```bash
# Install packages temporarily
nix-shell -p unzip curl wget git gcc gnumake

# Or add to configuration.nix:
# environment.systemPackages = with pkgs; [
#   unzip curl wget git gcc gnumake
# ];
```

### 🍎 macOS

#### Using Homebrew (Recommended)

```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install required tools
brew install unzip curl wget git

# Install additional development tools
brew install tree htop vim
```

#### Using MacPorts

```bash
# Install MacPorts from https://www.macports.org/install.php
# Then install required packages
sudo port install unzip curl wget git

# Install additional tools
sudo port install tree htop vim
```

### 📦 APKeep Installation

APKeep is essential for downloading APK files from various sources.

#### Linux (All Distributions)

```bash
# Automated installation script
curl -sSL https://raw.githubusercontent.com/EFForg/apkeep/main/install.sh | bash

# Manual installation (if script fails)
# Download latest release for your architecture
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    wget https://github.com/EFForg/apkeep/releases/latest/download/apkeep-linux-amd64
    chmod +x apkeep-linux-amd64
    sudo mv apkeep-linux-amd64 /usr/local/bin/apkeep
elif [ "$ARCH" = "aarch64" ]; then
    wget https://github.com/EFForg/apkeep/releases/latest/download/apkeep-linux-arm64
    chmod +x apkeep-linux-arm64
    sudo mv apkeep-linux-arm64 /usr/local/bin/apkeep
fi

# Verify installation
apkeep --version
```

#### macOS

```bash
# Automated installation
curl -sSL https://raw.githubusercontent.com/EFForg/apkeep/main/install.sh | bash

# Manual installation for Apple Silicon (M1/M2)
wget https://github.com/EFForg/apkeep/releases/latest/download/apkeep-darwin-arm64
chmod +x apkeep-darwin-arm64
sudo mv apkeep-darwin-arm64 /usr/local/bin/apkeep

# Manual installation for Intel Macs
wget https://github.com/EFForg/apkeep/releases/latest/download/apkeep-darwin-amd64
chmod +x apkeep-darwin-amd64
sudo mv apkeep-darwin-amd64 /usr/local/bin/apkeep
```

### 🎯 AssetRipper Installation (Recommended for Deep Analysis)

AssetRipper is a powerful tool for extracting and converting Unity assets to readable formats.

#### Linux

```bash
# Download and install AssetRipper
wget https://github.com/AssetRipper/AssetRipper/releases/latest/download/AssetRipper_linux_x64.zip
unzip AssetRipper_linux_x64.zip -d AssetRipper
chmod +x AssetRipper/AssetRipper

# Optional: Add to PATH
sudo ln -s $(pwd)/AssetRipper/AssetRipper /usr/local/bin/assetripper

# For GUI version (requires X11/Wayland)
./AssetRipper/AssetRipper

# For command line usage
./AssetRipper/AssetRipper --help
```

#### Linux (Arch-based) - AUR Package

```bash
# Using yay AUR helper
yay -S assetripper-bin

# Using paru AUR helper
paru -S assetripper-bin
```

#### macOS

```bash
# Download for macOS
curl -L -o AssetRipper_mac.zip https://github.com/AssetRipper/AssetRipper/releases/latest/download/AssetRipper_mac.zip
unzip AssetRipper_mac.zip -d AssetRipper
chmod +x AssetRipper/AssetRipper

# Run AssetRipper
./AssetRipper/AssetRipper
```

#### Advanced Usage Examples

```bash
# Extract Unity assets from base_assets folder
assetripper ./com.awesomepiece.castle_extracted/base_assets/ -o ./extracted_assets/

# Export specific file types only
assetripper ./base_assets/ -o ./assets/ --export-format=yaml --filter="*.prefab,*.unity"

# Command line batch processing
assetripper ./base_assets/ -o ./assets/ --no-gui --quiet
```

For comprehensive documentation, visit: [AssetRipper Repository](https://github.com/AssetRipper/AssetRipper)

## 📖 Usage Guide

### 🚀 Quick Start - Step-by-Step Workflow

Follow these simple steps to extract and analyze King God Castle APK:

#### Step 1: Extract the APK

```bash
# Make script executable (first time only)
chmod +x main.sh

# Run the extraction script
./main.sh com.awesomepiece.castle
```

#### Step 2: Open AssetRipper

```bash
# Launch AssetRipper GUI
assetripper

# Or if installed via AppImage
./AssetRipper.AppImage

# Or if using the downloaded binary
./AssetRipper/AssetRipper
```

#### Step 3: Load Extracted Assets

1. In AssetRipper, click **"File"** → **"Load folder"**
2. Navigate to and select: `./com.awesomepiece.castle_extracted/base_assets/`
3. Wait for AssetRipper to analyze all assets (this may take a few minutes)

#### Step 4: Export Unity Project

1. Once loading is complete, click **"Export"** → **"Export all files"**
2. Choose your export destination (e.g., `./unity_project/`)
3. Select export format:
   - **"Unity Project"** - Creates a complete Unity project
   - **"YAML"** - Human-readable text format
   - **"Native"** - Original asset format
4. Click **"Export"** and wait for completion

#### Complete Workflow Example

```bash
# One-liner: Extract and open AssetRipper
./main.sh com.awesomepiece.castle && assetripper

# Or with custom output directory
./main.sh com.awesomepiece.castle ./my_analysis && assetripper
```

### 🔧 Advanced Usage

#### Linux Command-Line Options

```bash
# Full extraction with verbose output
bash -x main.sh com.awesomepiece.castle ./extracted_games

# Background extraction with logging
nohup ./main.sh com.awesomepiece.castle > extraction_$(date +%Y%m%d_%H%M%S).log 2>&1 &

# Check progress of background job
tail -f extraction_*.log

# Extraction with custom source
./main.sh com.awesomepiece.castle ./output apk-pure

# Google Play extraction (requires credentials)
./main.sh com.awesomepiece.castle ./output google-play
```

#### Multi-Platform Execution

**Ubuntu/Debian:**

```bash
# Standard execution
./main.sh com.awesomepiece.castle

# With system monitoring
htop & ./main.sh com.awesomepiece.castle

# Using nice for low priority
nice -n 10 ./main.sh com.awesomepiece.castle
```

**Fedora/RHEL/CentOS:**

```bash
# With SELinux considerations
setsebool -P allow_execstack 1
./main.sh com.awesomepiece.castle

# Monitor system resources
watch -n 1 'df -h && free -h' & ./main.sh com.awesomepiece.castle
```

**Arch Linux:**

```bash
# Using systemd-run for isolation
systemd-run --user --scope ./main.sh com.awesomepiece.castle

# Monitor with journalctl
journalctl --user -f &
./main.sh com.awesomepiece.castle
```

**FreeBSD:**

```bash
# Install dependencies using pkg
sudo pkg update
sudo pkg install curl wget unzip git

# Execute with explicit bash
bash ./main.sh com.awesomepiece.castle

# Monitor with system tools
top & ./main.sh com.awesomepiece.castle
```

**OpenBSD:**

```bash
# Install dependencies using pkg_add
doas pkg_add curl wget unzip git bash

# Execute with bash (if default shell is ksh)
bash ./main.sh com.awesomepiece.castle

# Resource monitoring
vmstat 5 & ./main.sh com.awesomepiece.castle
```

**NetBSD:**

```bash
# Install dependencies using pkgin
sudo pkgin update
sudo pkgin install curl wget unzip git bash

# Execute script
bash ./main.sh com.awesomepiece.castle
```

**macOS/BSD:**

```bash
# Standard execution
./main.sh com.awesomepiece.castle

# With resource limits
ulimit -v 4194304 && ./main.sh com.awesomepiece.castle
```

### 📊 Parameters & Configuration

| Parameter          | Type     | Description        | Default    | Linux Examples                  |
| ------------------ | -------- | ------------------ | ---------- | ------------------------------- |
| `package_name`     | Required | Android package ID | -          | `com.awesomepiece.castle`       |
| `output_directory` | Optional | Extraction path    | `$(pwd)`   | `./analysis`, `/tmp/extraction` |
| `source`           | Optional | Download source    | `apk-pure` | `google-play`, `apk-pure`       |

#### Environment Variables (Linux)

```bash
# Set custom temporary directory
export TMPDIR=/var/tmp
./main.sh com.awesomepiece.castle

# Increase parallel processing
export EXTRACTION_THREADS=4
./main.sh com.awesomepiece.castle

# Debug mode
export DEBUG=1
./main.sh com.awesomepiece.castle
```

### 🎯 Post-Extraction Analysis (Linux Focus)

#### Using AssetRipper

```bash
# Command-line asset extraction
assetripper ./extracted/base_assets/ -o ./unity_project/ --export-format=yaml

# Batch processing multiple APKs
for apk in ./extracted/*_extracted/base_assets/; do
    assetripper "$apk" -o "./analysis/$(basename $apk)" --quiet
done

# Extract specific asset types
assetripper ./base_assets/ -o ./assets/ \
    --filter="*.prefab" \
    --filter="*.unity" \
    --filter="*.asset"

# GUI mode (if X11/Wayland available)
assetripper-gui ./extracted/base_assets/
```

#### Linux-Specific Analysis Tools

```bash
# File analysis with 'file' command
find ./extracted/ -type f -exec file {} \; | grep -E "(Unity|Mono|executable)"

# Strings analysis for interesting data
strings ./extracted/base_assets/lib/armeabi-v7a/libil2cpp.so | grep -E "(password|key|token|secret)" | head -20

# Binary analysis with objdump
objdump -T ./extracted/base_assets/lib/armeabi-v7a/libil2cpp.so | grep -i unity

# Entropy analysis (requires ent package)
sudo apt install ent
ent ./extracted/base_assets/assets/bin/Data/globalgamemanagers

# Network strings extraction
strings ./extracted/base_assets/assets/bin/Data/* | grep -E "http[s]?://|\.com|\.net|\.org" | sort -u

# Hexdump for binary inspection
hexdump -C ./extracted/base_assets/assets/bin/Data/level0 | head -50
```

#### Unity Asset Analysis

```bash
# Unity bundle extraction
python3 -c "
import os, zipfile
for root, dirs, files in os.walk('./extracted/base_assets/assets/'):
    for file in files:
        if file.endswith('.bundle'):
            print(f'Bundle found: {os.path.join(root, file)}')
"

# Asset database exploration
sqlite3 ./extracted/base_assets/assets/bin/Data/unity\ default\ resources << EOF
.tables
.schema
SELECT * FROM sqlite_master WHERE type='table';
EOF

# Scene file analysis
find ./extracted/ -name "*.unity" -exec echo "Scene: {}" \; -exec hexdump -C {} \; | head -100
```

#### Security Analysis (Linux)

```bash
# Check for anti-debug mechanisms
grep -r "ptrace\|debugger\|gdb" ./extracted/

# Look for encryption/obfuscation
strings ./extracted/base_assets/lib/armeabi-v7a/* | grep -E "(encrypt|decrypt|obfuscat|protect)"

# Analyze shared libraries
ldd ./extracted/base_assets/lib/armeabi-v7a/libil2cpp.so 2>/dev/null || echo "Unix cross-platform binary"

# Check for root detection
grep -r -i "root\|superuser\|magisk\|xposed" ./extracted/base_assets/

# Search for API endpoints
grep -r -E "api\.|/api/|endpoint" ./extracted/ | head -20
```

### 🔍 Advanced Linux Workflows

#### Automated Analysis Pipeline

```bash
#!/bin/bash
# analysis_pipeline.sh

PACKAGE="com.awesomepiece.castle"
OUTPUT_DIR="./analysis_$(date +%Y%m%d_%H%M%S)"

echo "Starting analysis pipeline for $PACKAGE..."

# Step 1: Extract APK
./main.sh "$PACKAGE" "$OUTPUT_DIR"

# Step 2: Asset analysis
assetripper "$OUTPUT_DIR/${PACKAGE}_extracted/base_assets/" -o "$OUTPUT_DIR/unity_assets/"

# Step 3: Security scan
echo "=== Security Analysis ===" > "$OUTPUT_DIR/security_report.txt"
grep -r -i "password\|secret\|key\|token" "$OUTPUT_DIR/${PACKAGE}_extracted/" >> "$OUTPUT_DIR/security_report.txt"

# Step 4: Generate summary
echo "=== Analysis Summary ===" > "$OUTPUT_DIR/summary.txt"
echo "Package: $PACKAGE" >> "$OUTPUT_DIR/summary.txt"
echo "Extraction Date: $(date)" >> "$OUTPUT_DIR/summary.txt"
echo "Total Files: $(find "$OUTPUT_DIR" -type f | wc -l)" >> "$OUTPUT_DIR/summary.txt"
echo "Total Size: $(du -sh "$OUTPUT_DIR" | cut -f1)" >> "$OUTPUT_DIR/summary.txt"

echo "Analysis complete! Results in $OUTPUT_DIR"
```

#### Batch Processing Script

```bash
#!/bin/bash
# batch_analysis.sh

PACKAGES=(
    "com.awesomepiece.castle"
    "com.example.game1"
    "com.example.game2"
)

for package in "${PACKAGES[@]}"; do
    echo "Processing $package..."
    mkdir -p "./batch_results/$package"
    ./main.sh "$package" "./batch_results/$package"

    if [ $? -eq 0 ]; then
        echo "✅ $package extracted successfully"
    else
        echo "❌ $package extraction failed"
    fi
done

echo "Batch processing complete!"
```

#### System Resource Monitoring

```bash
# Monitor system resources during extraction
#!/bin/bash
# resource_monitor.sh

LOG_FILE="resource_usage_$(date +%Y%m%d_%H%M%S).log"

# Start monitoring in background
{
    while true; do
        echo "$(date): CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1), RAM=$(free | grep Mem | awk '{printf "%.1f%%", $3/$2 * 100.0}'), DISK=$(df -h . | tail -1 | awk '{print $5}')"
        sleep 5
    done
} > "$LOG_FILE" &

MONITOR_PID=$!

# Run extraction
./main.sh com.awesomepiece.castle

# Stop monitoring
kill $MONITOR_PID

echo "Resource usage logged to $LOG_FILE"
```

## 🛠️ Script Workflow Breakdown

### Phase 1: Pre-flight Checks

```bash
# Dependencies verification
command -v apkeep >/dev/null 2>&1 || { echo "APKeep not found"; exit 1; }
command -v unzip >/dev/null 2>&1 || { echo "unzip not found"; exit 1; }

# Disk space check (requires ~1GB)
AVAILABLE=$(df . | tail -1 | awk '{print $4}')
REQUIRED=1048576  # 1GB in KB
[ $AVAILABLE -lt $REQUIRED ] && { echo "Insufficient disk space"; exit 1; }
```

### Phase 2: Download Process

```bash
# Download XAPK with progress monitoring
apkeep -a "$PACKAGE_NAME" -d "$SOURCE" "$OUTPUT_DIR" 2>&1 | \
    tee download.log | \
    grep -o '[0-9]*%' | \
    tail -1
```

### Phase 3: Extraction Pipeline

```bash
# Multi-stage extraction with validation
extract_and_validate() {
    local file="$1"
    local dest="$2"

    echo "Extracting $file..."
    unzip -q "$file" -d "$dest" && \
    echo "✅ Extracted: $(find "$dest" -type f | wc -l) files" || \
    echo "❌ Extraction failed for $file"
}
```

### Phase 4: Asset Organization

```bash
# Intelligent library reorganization
reorganize_libs() {
    if [ -d "$CONFIG_DIR/lib" ] && [ -d "$BASE_ASSETS_DIR" ]; then
        echo "Moving native libraries..."
        rsync -av "$CONFIG_DIR/lib/" "$BASE_ASSETS_DIR/lib/"
        rm -rf "$CONFIG_DIR/lib"
        echo "✅ Libraries reorganized"
    fi
}
```

## 🎮 Game Information & Technical Details

### King God Castle Specifications

- **Package**: `com.awesomepiece.castle`
- **Version**: 156.0.01 (Build 948)
- **Developer**: AwesomePiece
- **Engine**: Unity 2022.3+ with IL2CPP
- **Min SDK**: Android 24 (Android 7.0+)
- **Target SDK**: Android 34 (Android 14)
- **Architecture**: ARMv7a primary, ARM64 support
- **Size**: ~758MB (XAPK format)
- **Localization**: 40+ languages supported

### Detected Technologies

```
🔧 Core Technologies:
├── Unity Engine (2022.3+)
├── IL2CPP Runtime
├── Addressables Asset System
├── Unity Analytics
└── Unity Cloud Build

🔐 Security & Anti-Cheat:
├── ACTk (Anti-Cheat Toolkit)
├── Code Obfuscation
├── Runtime Protection
└── Certificate Pinning

📱 Mobile Integration:
├── Firebase (Analytics, Crashlytics, Messaging)
├── Google Play Services
├── In-App Billing v4
├── Unity Ads
└── Social Platforms

⚡ Performance & UI:
├── Odin Inspector/Serializer
├── UniRx (Reactive Programming)
├── DOTween Animation
├── Unity UI Toolkit
└── Addressable Resources
```

## 🔍 Advanced Analysis Capabilities

### Code Analysis

```bash
# IL2CPP Disassembly (if tools available)
if command -v il2cppdumper >/dev/null 2>&1; then
    il2cppdumper ./extracted/base_assets/lib/armeabi-v7a/libil2cpp.so \
                 ./extracted/base_assets/assets/bin/Data/Managed/Metadata/global-metadata.dat \
                 ./code_analysis/
fi

# Assembly Analysis
find ./extracted/ -name "*.dll" -exec echo "Assembly: {}" \; -exec file {} \;

# Managed Code Inspection
strings ./extracted/base_assets/assets/bin/Data/Managed/Metadata/global-metadata.dat | \
    grep -E "class|method|property" | head -50
```

### Asset Deep Dive

```bash
# Unity Addressables Analysis
find ./extracted/ -name "addressable*" -o -name "*catalog*" -exec cat {} \;

# Texture Analysis
identify ./extracted/base_assets/assets/**/*.png 2>/dev/null | \
    awk '{print $3}' | sort | uniq -c | sort -nr | head -10

# Audio Analysis
find ./extracted/ -name "*.ogg" -o -name "*.wav" -exec mediainfo {} \; | \
    grep -E "Duration|Bit rate|Format" | head -20
```

### Network & Security Analysis

```bash
# Certificate Analysis
find ./extracted/ -name "*.cer" -o -name "*.crt" -o -name "*.pem" -exec openssl x509 -in {} -text -noout \;

# API Endpoint Discovery
grep -r -E "https?://[^\"']*" ./extracted/ | \
    grep -v Binary | \
    cut -d: -f2- | \
    sort -u | \
    head -20

# Privacy & Permissions Analysis
grep -A 20 -B 5 "permission" ./extracted/base_assets/AndroidManifest.xml
```

## ⚠️ Legal & Ethical Guidelines

### Educational Use Policy

This tool is designed for **legitimate educational and research purposes**:

- ✅ **Allowed**: Personal learning, security research, academic study
- ✅ **Allowed**: Analysis of apps you own or have explicit permission to examine
- ✅ **Allowed**: Security vulnerability research (responsible disclosure)
- ❌ **Forbidden**: Commercial exploitation of extracted content
- ❌ **Forbidden**: Redistribution of copyrighted assets
- ❌ **Forbidden**: Circumventing copy protection for piracy

### Research Best Practices

```bash
# Document your research
echo "Research started: $(date)" > research_log.txt
echo "Purpose: Security analysis of mobile game architecture" >> research_log.txt
echo "Legal basis: Educational use, owned application" >> research_log.txt

# Secure handling of sensitive data
chmod 700 ./extracted/
chown $USER:$USER ./extracted/ -R

# Clean up when done
# rm -rf ./extracted/  # Uncomment when analysis complete
```

## 🤝 Contributing & Development

### Contributing Guidelines

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Test** on multiple Linux distributions
4. **Document** changes in commit messages
5. **Submit** a pull request

### Development Environment Setup

```bash
# Clone for development
git clone https://github.com/nowl-it/King-God-Castle.git
cd King-God-Castle

# Set up development environment
chmod +x main.sh

# Install development dependencies
sudo apt install -y shellcheck shfmt

# Run tests
shellcheck main.sh
shfmt -d main.sh

# Set up git hooks
echo '#!/bin/bash
shellcheck main.sh && shfmt -d main.sh' > .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

### Testing Framework

```bash
# Test on different distributions
docker run -v $(pwd):/workspace ubuntu:22.04 bash -c "cd /workspace && ./main.sh --help"
docker run -v $(pwd):/workspace fedora:38 bash -c "cd /workspace && ./main.sh --help"
docker run -v $(pwd):/workspace archlinux:latest bash -c "cd /workspace && ./main.sh --help"
```

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

### Reverse Engineering Disclaimer

This software is provided for **educational, research, and security analysis purposes only**. By using this software, you agree to:

- ✅ Only analyze applications you own or have explicit permission to analyze
- ✅ Respect intellectual property rights and copyright laws
- ✅ Comply with applicable reverse engineering laws in your jurisdiction
- ✅ Use findings responsibly (e.g., responsible disclosure for security issues)
- ❌ Not redistribute or share copyrighted content extracted using this tool
- ❌ Not use for commercial exploitation without proper licensing

**Legal Notice**: The authors are not responsible for any misuse of this software or legal consequences arising from its use. Users are solely responsible for ensuring their use complies with all applicable laws and regulations.

## 🐛 Troubleshooting & Support

### Common Linux Issues

#### Permission Errors

```bash
# Fix script permissions
chmod +x main.sh

# Fix output directory permissions
chmod 755 ./extracted/

# SELinux context issues (RHEL/CentOS/Fedora)
sudo setsebool -P allow_execstack 1
sudo chcon -R -t admin_home_t ./extracted/
```

#### Dependency Issues

```bash
# Missing apkeep
curl -sSL https://raw.githubusercontent.com/EFForg/apkeep/main/install.sh | bash

# Missing unzip
sudo apt install unzip  # Ubuntu/Debian
sudo dnf install unzip  # Fedora/RHEL
sudo pacman -S unzip    # Arch Linux

# Missing curl/wget
sudo apt install curl wget  # Ubuntu/Debian
sudo dnf install curl wget  # Fedora/RHEL
```

#### Storage Issues

```bash
# Check available space
df -h .

# Clean up temporary files
rm -rf /tmp/apkeep_*
rm -rf ~/.cache/apkeep/

# Use different temporary directory
export TMPDIR=/var/tmp
./main.sh com.awesomepiece.castle
```

#### Network Issues

```bash
# Test apkeep connectivity
apkeep --help

# Use different source
./main.sh com.awesomepiece.castle ./output google-play

# Manual download (if apkeep fails)
# Visit APK-Pure manually and download, then extract with:
# unzip downloaded_file.xapk -d extracted/
```

### Performance Optimization

#### For Low-End Systems

```bash
# Use nice to lower priority
nice -n 19 ./main.sh com.awesomepiece.castle

# Limit memory usage
ulimit -v 2097152  # 2GB virtual memory limit
./main.sh com.awesomepiece.castle

# Monitor resource usage
htop &
./main.sh com.awesomepiece.castle
```

#### For High-End Systems

```bash
# Parallel processing (if supported)
export EXTRACTION_THREADS=8
./main.sh com.awesomepiece.castle

# Use SSD for faster I/O
mkdir /tmp/fast_extraction
export TMPDIR=/tmp/fast_extraction
./main.sh com.awesomepiece.castle
```

### Debug Mode

```bash
# Enable debug output
export DEBUG=1
bash -x ./main.sh com.awesomepiece.castle 2>&1 | tee debug.log

# Verbose unzip operations
export UNZIP_OPTS="-v"
./main.sh com.awesomepiece.castle
```

## 📞 Support Channels

### Getting Help

- 🐛 **Issues**: [GitHub Issues](https://github.com/nowl-it/King-God-Castle/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/nowl-it/King-God-Castle/discussions)
- 📖 **Documentation**: This README and inline script comments
- 🔧 **APKeep Support**: [APKeep Repository](https://github.com/EFForg/apkeep)
- 🎮 **AssetRipper Support**: [AssetRipper Repository](https://github.com/AssetRipper/AssetRipper)

### Reporting Issues

When reporting issues, please include:

```bash
# System information
uname -a
lsb_release -a 2>/dev/null || cat /etc/os-release

# Tool versions
apkeep --version
unzip -v | head -1
bash --version | head -1

# Error log
./main.sh com.awesomepiece.castle 2>&1 | tee error.log
# Attach error.log to your issue report
```
