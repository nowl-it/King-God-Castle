#!/bin/bash

# Script to download and extract an APK file using apkeep, extract base_assets.apk and config.*.apk,
# and move the lib folder from config to base_assets
# Usage: ./download_apk.sh <package_name> [output_directory] [source]
# Example: ./download_apk.sh com.example.app ./apks apk-pure

# Function to display usage
usage() {
    echo "Usage: $0 <package_name> [output_directory] [source]"
    echo "  package_name: The package name of the app (e.g., com.example.app)"
    echo "  output_directory: Directory to save the APK and extracted files (default: current directory)"
    echo "  source: Download source (apk-pure or google-play, default: apk-pure)"
    echo "Example: $0 com.instagram.android ./apks apk-pure"
    exit 1
}

# Check if apkeep is installed
if ! command -v apkeep &>/dev/null; then
    echo "Error: apkeep is not installed."
    echo "On Termux, install it with: pkg install apkeep"
    echo "On Linux, refer to: https://github.com/EFForg/apkeep"
    exit 1
fi

# Check if unzip is installed
if ! command -v unzip &>/dev/null; then
    echo "Error: unzip is not installed."
    echo "On Termux, install it with: pkg install unzip"
    echo "On Linux, install it with: sudo apt install unzip (Ubuntu/Debian) or equivalent"
    exit 1
fi

# Check if package name is provided
if [ -z "$1" ]; then
    echo "Error: Package name is required."
    usage
fi

PACKAGE_NAME="$1"
OUTPUT_DIR="${2:-$(pwd)}" # Default to current directory if not specified
SOURCE="${3:-apk-pure}"   # Default to apk-pure if not specified

# Validate source
if [ "$SOURCE" != "apk-pure" ] && [ "$SOURCE" != "google-play" ]; then
    echo "Error: Invalid source. Use 'apk-pure' or 'google-play'."
    usage
fi

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"
if [ $? -ne 0 ]; then
    echo "Error: Failed to create output directory '$OUTPUT_DIR'."
    exit 1
fi

# Download APK
echo "Downloading APK for $PACKAGE_NAME from $SOURCE..."

if [ "$SOURCE" = "apk-pure" ]; then
    apkeep -a "$PACKAGE_NAME" -d "$SOURCE" "$OUTPUT_DIR"
elif [ "$SOURCE" = "google-play" ]; then
    # For Google Play, prompt for email and AAS token
    echo "Google Play requires an email and AAS token."
    read -p "Enter Google Play email: " EMAIL
    read -p "Enter AAS token: " AAS_TOKEN
    apkeep -a "$PACKAGE_NAME" -d "$SOURCE" -e "$EMAIL" -t "$AAS_TOKEN" "$OUTPUT_DIR"
fi

# Check if download was successful
if [ $? -eq 0 ]; then
    echo "APK downloaded successfully to $OUTPUT_DIR"
else
    echo "Error: Failed to download APK."
    exit 1
fi

# Find the downloaded APK file (assuming apkeep names it as <package_name>.xapk)
APK_FILE=$(find "$OUTPUT_DIR" -maxdepth 1 -name "${PACKAGE_NAME}.xapk" | head -n 1)
if [ -z "$APK_FILE" ]; then
    echo "Error: No APK file found for $PACKAGE_NAME in $OUTPUT_DIR."
    exit 1
fi

# Create extraction directory
EXTRACT_DIR="$OUTPUT_DIR/${PACKAGE_NAME}_extracted"
mkdir -p "$EXTRACT_DIR"
if [ $? -ne 0 ]; then
    echo "Error: Failed to create extraction directory '$EXTRACT_DIR'."
    exit 1
fi

# Extract the main APK
echo "Extracting main APK to $EXTRACT_DIR..."
unzip -o "$APK_FILE" -d "$EXTRACT_DIR"
if [ $? -eq 0 ]; then
    echo "Main APK extracted successfully to $EXTRACT_DIR"
else
    echo "Error: Failed to extract main APK."
    exit 1
fi

# Extract base_assets.apk
BASE_ASSETS_APK="$EXTRACT_DIR/base_assets.apk"
BASE_ASSETS_DIR="$EXTRACT_DIR/base_assets"
if [ -f "$BASE_ASSETS_APK" ]; then
    echo "Extracting base_assets.apk to $BASE_ASSETS_DIR..."
    mkdir -p "$BASE_ASSETS_DIR"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to create base_assets directory '$BASE_ASSETS_DIR'."
        exit 1
    fi
    unzip -o "$BASE_ASSETS_APK" -d "$BASE_ASSETS_DIR"
    if [ $? -eq 0 ]; then
        echo "base_assets.apk extracted successfully to $BASE_ASSETS_DIR"
    else
        echo "Error: Failed to extract base_assets.apk."
        exit 1
    fi
else
    echo "Warning: base_assets.apk not found in $EXTRACT_DIR."
fi

# Extract config.*.apk files
CONFIG_DIR="$EXTRACT_DIR/config"
mkdir -p "$CONFIG_DIR"
if [ $? -ne 0 ]; then
    echo "Error: Failed to create config directory '$CONFIG_DIR'."
    exit 1
fi

CONFIG_APKS=$(find "$EXTRACT_DIR" -maxdepth 1 -name "config.*.apk")
if [ -n "$CONFIG_APKS" ]; then
    for CONFIG_APK in $CONFIG_APKS; do
        echo "Extracting $(basename "$CONFIG_APK") to $CONFIG_DIR..."
        unzip -o "$CONFIG_APK" -d "$CONFIG_DIR"
        if [ $? -eq 0 ]; then
            echo "$(basename "$CONFIG_APK") extracted successfully to $CONFIG_DIR"
        else
            echo "Error: Failed to extract $(basename "$CONFIG_APK")."
            exit 1
        fi
    done
else
    echo "Warning: No config.*.apk files found in $EXTRACT_DIR."
fi

# Move lib folder from config to base_assets
LIB_DIR="$CONFIG_DIR/lib"
DEST_LIB_DIR="$BASE_ASSETS_DIR/lib"
if [ -d "$LIB_DIR" ]; then
    echo "Moving lib folder from $CONFIG_DIR to $BASE_ASSETS_DIR..."
    mv "$LIB_DIR" "$DEST_LIB_DIR"
    if [ $? -eq 0 ]; then
        echo "lib folder moved successfully to $DEST_LIB_DIR"
    else
        echo "Error: Failed to move lib folder."
        exit 1
    fi
else
    echo "Warning: lib folder not found in $CONFIG_DIR."
fi

echo "APK extraction and processing completed successfully."
echo "All files are located in $OUTPUT_DIR"
echo "You can now use the extracted files as needed."
echo "Script finished."
