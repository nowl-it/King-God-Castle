#!/bin/bash

# APK Download and Extraction Tool for Knight's Game Castle
# Downloads and extracts APK files using apkeep with proper structure handling

set -euo pipefail # Exit on errors, undefined variables, and pipe failures

# Configuration
readonly PACKAGE_NAME="com.awesomepiece.castle"
SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_NAME

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $*"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

usage() {
    cat <<EOF
${SCRIPT_NAME} - APK Download and Extraction Tool

USAGE:
    ${SCRIPT_NAME} [OPTIONS] [OUTPUT_DIR]

ARGUMENTS:
    OUTPUT_DIR    Directory to save APK and extracted files (default: current directory)

OPTIONS:
    -h, --help    Show this help message
    -v, --verbose Enable verbose output
    -q, --quiet   Suppress non-error output

EXAMPLES:
    ${SCRIPT_NAME}                          # Download to current directory
    ${SCRIPT_NAME} ./apks                   # Download to ./apks directory
    ${SCRIPT_NAME} -v ./downloads           # Verbose download to ./downloads

DEPENDENCIES:
    - apkeep: APK downloading tool
    - unzip:  Archive extraction tool

For more information about apkeep, visit: https://github.com/EFForg/apkeep
EOF
}

check_dependencies() {
    local missing_deps=()

    if ! command -v apkeep &>/dev/null; then
        missing_deps+=("apkeep")
    fi

    if ! command -v unzip &>/dev/null; then
        missing_deps+=("unzip")
    fi

    if [ ${#missing_deps[@]} -gt 0 ]; then
        log_error "Missing required dependencies: ${missing_deps[*]}"
        echo
        echo "Installation instructions:"
        if [[ "${missing_deps[*]}" =~ "apkeep" ]]; then
            echo "  apkeep:"
            echo "    - Linux: https://github.com/EFForg/apkeep"
        fi
        if [[ "${missing_deps[*]}" =~ "unzip" ]]; then
            echo "  unzip:"
            echo "    - Ubuntu/Debian: sudo apt install unzip"
            echo "    - RHEL/CentOS: sudo yum install unzip"
        fi
        exit 1
    fi
}

create_directory() {
    local dir="$1"
    local description="$2"

    if ! mkdir -p "$dir" 2>/dev/null; then
        log_error "Failed to create $description directory: $dir"
        exit 1
    fi

    if [ ! -d "$dir" ]; then
        log_error "$description directory does not exist after creation: $dir"
        exit 1
    fi
}

download_apk() {
    local output_dir="$1"
    local apk_file="$output_dir/${PACKAGE_NAME}.xapk"

    apkeep -a "$PACKAGE_NAME" -d apk-pure "$output_dir"
    
    echo "$apk_file"
}

extract_archive() {
    local archive_file="$1"
    local extract_dir="$2"
    local description="$3"

    log_info "Extracting $description to $extract_dir..."

    if ! unzip -oq "$archive_file" -d "$extract_dir" 2>/dev/null; then
        log_error "Failed to extract $description"
        exit 1
    fi

    log_success "$description extracted successfully"
}

process_base_assets() {
    local extract_dir="$1"
    local base_assets_apk="$extract_dir/base_assets.apk"
    local base_assets_dir="$extract_dir/base_assets"

    if [ -f "$base_assets_apk" ]; then
        create_directory "$base_assets_dir" "base assets"
        extract_archive "$base_assets_apk" "$base_assets_dir" "base_assets.apk"
        return 0
    else
        log_warning "base_assets.apk not found in $extract_dir"
        return 1
    fi
}

process_config_apks() {
    local extract_dir="$1"
    local config_dir="$extract_dir/config"

    create_directory "$config_dir" "config"

    local config_apks
    config_apks=$(find "$extract_dir" -maxdepth 1 -name "config.*.apk" 2>/dev/null || true)

    if [ -n "$config_apks" ]; then
        local count=0
        while IFS= read -r config_apk; do
            [ -f "$config_apk" ] || continue
            extract_archive "$config_apk" "$config_dir" "$(basename "$config_apk")"
            ((count++))
        done <<<"$config_apks"

        log_info "Processed $count config APK(s)"
        return 0
    else
        log_warning "No config.*.apk files found in $extract_dir"
        return 1
    fi
}

move_lib_folder() {
    local config_dir="$1"
    local base_assets_dir="$2"
    local lib_dir="$config_dir/lib"
    local dest_lib_dir="$base_assets_dir/lib"

    if [ -d "$lib_dir" ]; then
        log_info "Moving lib folder from config to base_assets..."

        if ! mv "$lib_dir" "$dest_lib_dir" 2>/dev/null; then
            log_error "Failed to move lib folder"
            exit 1
        fi

        log_success "lib folder moved successfully to $dest_lib_dir"
        return 0
    else
        log_warning "lib folder not found in $config_dir"
        return 1
    fi
}

main() {
    local output_dir
    local verbose=false
    local quiet=false
    local apk_file
    local extract_dir
    local has_base_assets=false
    local has_config=false

    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
        -h | --help)
            usage
            exit 0
            ;;
        -v | --verbose)
            verbose=true
            shift
            ;;
        -q | --quiet)
            quiet=true
            shift
            ;;
        -*)
            log_error "Unknown option: $1"
            usage
            exit 1
            ;;
        *)
            if [ -z "${output_dir:-}" ]; then
                output_dir="$1"
            else
                log_error "Too many arguments"
                usage
                exit 1
            fi
            shift
            ;;
        esac
    done

    # Set defaults
    output_dir="${output_dir:-$(pwd)}"

    # Set quiet mode if requested
    if [ "$quiet" = true ]; then
        exec 1>/dev/null
    fi

    # Check dependencies
    echo "--- Checking dependencies ---"
    check_dependencies

    echo "--- Starting APK download and extraction process ---"
    log_info "Package: $PACKAGE_NAME"
    log_info "Output directory: $output_dir"
    log_info "Source: apk-pure"

    # Create output directory
    echo "--- Checking output directory: $output_dir  ---"
    create_directory "$output_dir" "output"

    # Download APK
    echo "--- Downloading APK ---"
    apk_file=$(download_apk "$output_dir")
    log_success "APK downloaded successfully: $apk_file"

    # Set up extraction directory
    echo "--- Setting up extraction directory ---"
    extract_dir="$output_dir/${PACKAGE_NAME}_extracted"
    create_directory "$extract_dir" "extraction"

    # Extract main APK
    echo "--- Extracting main APK ---"
    log_info "Extracting main APK from $apk_file to $extract_dir"
    extract_archive "$apk_file" "$extract_dir" "main XAPK"

    # Process base assets
    if process_base_assets "$extract_dir"; then
        has_base_assets=true
    fi

    # Process config APKs
    if process_config_apks "$extract_dir"; then
        has_config=true
    fi

    # Move lib folder if both base_assets and config exist
    if [ "$has_base_assets" = true ] && [ "$has_config" = true ]; then
        move_lib_folder "$extract_dir/config" "$extract_dir/base_assets"
    fi

    # Final summary
    echo "--- Summary ---"
    log_success "APK extraction and processing completed successfully!"
    log_info "Files location: $output_dir"
    log_info "Extracted content: $extract_dir"

    if [ "$verbose" = true ]; then
        echo
        log_info "Directory structure:"
        find "$extract_dir" -type d | head -20 | while read -r dir; do
            echo "  $dir"
        done
    fi

    log_info "Process finished"
}

# Run main function with all arguments
main "$@"
