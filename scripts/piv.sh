#!/bin/bash
# piv.sh - Universal AI Dev Framework installer for Cursor and other AI tools
# For Claude Code, use: /plugin install piv@universal-ai-dev-framework

set -euo pipefail

################################################################################
# CONFIGURATION
################################################################################

readonly SCRIPT_VERSION="2.1.0"
readonly REPO_URL="https://github.com/galando/piv-speckit"
readonly REPO_NAME="universal-ai-dev-framework"

# User options
PIV_TAG=""
DRY_RUN=false
AUTO_CONFIRM=false
TOOL=""  # cursor | copilot | (empty = all)

# Working directory
ORIGINAL_DIR="$(pwd)"
SCRIPT_DIR=""

################################################################################
# CURL | BASH ENTRY POINT
################################################################################

# Check if running from stdin (via curl | bash)
if [ -z "${BASH_SOURCE+x}" ] || [ "${BASH_SOURCE[0]}" = "bash" ] || [ "${BASH_SOURCE[0]}" = "/dev/stdin" ]; then
    echo "🌐 Universal AI Dev Framework - Downloading..."

    # Create temp directory
    TEMP_DIR=$(mktemp -d) || {
        echo "Error: Cannot create temp directory"
        exit 1
    }

    # Check for git
    if ! command -v git &> /dev/null; then
        echo "Error: git is required"
        rm -rf "$TEMP_DIR"
        exit 1
    fi

    # Clone repository (from specific tag if requested)
    echo "Downloading from GitHub..."
    if [ -n "$PIV_TAG" ]; then
        echo "Fetching tag: $PIV_TAG"
        if ! git clone --depth 1 --branch "$PIV_TAG" -q "https://github.com/galando/$REPO_NAME.git" "$TEMP_DIR" 2>/dev/null; then
            echo "Error: Failed to download tag '$PIV_TAG'"
            rm -rf "$TEMP_DIR"
            exit 1
        fi
    else
        if ! git clone --depth 1 -q "https://github.com/galando/$REPO_NAME.git" "$TEMP_DIR" 2>/dev/null; then
            echo "Error: Failed to download"
            rm -rf "$TEMP_DIR"
            exit 1
        fi
    fi

    # Change to original directory (with fallback)
    cd "$ORIGINAL_DIR" 2>/dev/null || cd /

    # Run the real script with all arguments
    bash "$TEMP_DIR/scripts/piv.sh" "$@" < /dev/tty
    EXIT_CODE=$?

    # Clean up
    rm -rf "$TEMP_DIR"

    exit $EXIT_CODE
fi

################################################################################
# SCRIPT INITIALIZATION
################################################################################

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source generators
source "$SCRIPT_DIR/install/generate-agents-md.sh"
source "$SCRIPT_DIR/install/generate-cursor-rules.sh"
source "$SCRIPT_DIR/install/generate-copilot-instructions.sh"
source "$SCRIPT_DIR/install/generate-specs-templates.sh"

################################################################################
# ARGUMENT PARSING
################################################################################

print_usage() {
    cat << EOF
Usage: piv.sh [OPTIONS]

Universal AI Dev Framework installer for Cursor and Copilot.

OPTIONS:
    --tool <name>      Install for specific tool: cursor | copilot
    --tag vX.Y.Z       Install from specific release tag (e.g., v1.0.0)
    --dry-run          Show changes without applying
    --help             Show this help message
    -v, --version      Show version information

EXAMPLES:
    # Install for Cursor only
    curl -s $REPO_URL/raw/main/scripts/piv.sh | bash -s -- --tool cursor

    # Install for Copilot only
    curl -s $REPO_URL/raw/main/scripts/piv.sh | bash -s -- --tool copilot

    # Install all tool configurations
    curl -s $REPO_URL/raw/main/scripts/piv.sh | bash

    # Install specific release for Cursor
    curl -s $REPO_URL/raw/main/scripts/piv.sh | bash -s -- --tool cursor --tag v2.0.0

For Claude Code full experience:
    /plugin marketplace add galando/piv-speckit/marketplace
    /plugin install piv@universal-ai-dev-framework

For more information: $REPO_URL
EOF
}

show_version() {
    local version
    version=$(cat "$SCRIPT_DIR/../VERSION" 2>/dev/null || echo "unknown")
    cat << EOF
Universal AI Dev Framework Installer v$SCRIPT_VERSION
PIV Framework Version: $version
Repository: $REPO_URL
EOF
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --tool=*)
            TOOL="$(echo "${1#*=}" | tr '[:upper:]' '[:lower:]')"
            shift
            ;;
        --tool)
            TOOL="$(echo "$2" | tr '[:upper:]' '[:lower:]')"
            shift 2
            ;;
        --tag=*)
            PIV_TAG="${1#*=}"
            shift
            ;;
        --tag)
            PIV_TAG="$2"
            shift 2
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --help|-h)
            print_usage
            exit 0
            ;;
        -v|--version)
            show_version
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Validate tool option if provided
if [[ -n "$TOOL" && "$TOOL" != "cursor" && "$TOOL" != "copilot" ]]; then
    echo "Error: Invalid tool '$TOOL'"
    echo "Supported tools: cursor, copilot"
    echo ""
    print_usage
    exit 1
fi

################################################################################
# BANNER
################################################################################

print_banner() {
    cat << "EOF"

╔═══════════════════════════════════════════════════════════════════════╗
║                                                                        ║
║            Universal AI Dev Framework - PIV Methodology                ║
║                                                                        ║
║      Works with: Cursor • GitHub Copilot • OpenAI Codex • More        ║
║                                                                        ║
║      For Claude Code full experience:                                  ║
║      /plugin marketplace add galando/piv-speckit/marketplace
║      /plugin install piv@universal-ai-dev-framework                    ║
║                                                                        ║
╚═══════════════════════════════════════════════════════════════════════╝

EOF
}

################################################################################
# CONFIRMATION
################################################################################

confirm_install() {
    if [ "$AUTO_CONFIRM" = true ]; then
        return 0
    fi

    # Check if already installed
    if [ -f "$ORIGINAL_DIR/AGENTS.md" ] && [ -d "$ORIGINAL_DIR/.cursor/rules" ]; then
        echo "⚠️  PIV already installed in this directory"
        echo ""
        read -p "Reinstall/update? [y/N]: " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Aborted."
            exit 0
        fi
    fi

    return 0
}

################################################################################
# MAIN FLOW
################################################################################

main() {
    local target_dir="${1:-$ORIGINAL_DIR}"

    print_banner
    confirm_install

    # Show selected tool if specified
    if [[ -n "$TOOL" ]]; then
        echo "🔧 Tool: $TOOL"
    fi
    echo ""
    echo "📦 Installing Universal AI Dev Framework..."
    echo ""

    # 1. Generate AGENTS.md (always - for all AI tools)
    echo "📄 Generating AGENTS.md..."
    generate_agents_md "$target_dir/AGENTS.md"

    # 2. Generate tool-specific rules
    if [[ -z "$TOOL" || "$TOOL" == "cursor" ]]; then
        echo ""
        echo "📁 Generating .cursor/rules/..."
        generate_cursor_rules "$target_dir"
    fi

    if [[ -z "$TOOL" || "$TOOL" == "copilot" ]]; then
        echo ""
        echo "📁 Generating .github/copilot-instructions.md..."
        generate_copilot_instructions "$target_dir"
    fi

    # 3. Generate .specs/.templates/ and constitution template
    echo ""
    echo "📁 Generating .specs/.templates/..."
    generate_specs_templates "$target_dir"

    echo ""
    echo "════════════════════════════════════════════════════════════════════"
    echo "✅ PIV Spec-Kit installed successfully!"
    echo "════════════════════════════════════════════════════════════════════"
    echo ""
    echo "📄 AGENTS.md              - Core PIV methodology (auto-loaded)"

    # Show installed tool files
    if [[ -z "$TOOL" || "$TOOL" == "cursor" ]]; then
        echo "📁 .cursor/rules/         - Auto-attach rules for Cursor"
    fi
    if [[ -z "$TOOL" || "$TOOL" == "copilot" ]]; then
        echo "📁 .github/copilot-instructions.md - Auto-load rules for Copilot"
    fi

    echo "📁 .specs/.templates/     - Spec, plan, and task templates"
    echo "📄 constitution.template.md - Project constitution template"
    echo ""
    echo "🚀 NEXT STEPS:"
    echo ""
    echo "1. Create your constitution:"
    echo "   cp constitution.template.md constitution.md"
    echo "   # Then customize it for your project"
    echo ""
    echo "2. Start using PIV workflow:"
    echo "   • Prime: \"Analyze this codebase\""
    echo "   • Plan:  \"Plan feature X in .specs/X/\""
    echo "   • Execute: \"Implement tasks.md using TDD\""
    echo ""
    echo "📚 Guides:"
    if [[ -z "$TOOL" || "$TOOL" == "cursor" ]]; then
        echo "   • Cursor:  $REPO_URL/blob/main/docs/getting-started/06-cursor-guide.md"
    fi
    if [[ -z "$TOOL" || "$TOOL" == "copilot" ]]; then
        echo "   • Copilot: $REPO_URL/blob/main/docs/getting-started/07-copilot-guide.md"
    fi
    echo ""
}

# Run main
main "$@"
