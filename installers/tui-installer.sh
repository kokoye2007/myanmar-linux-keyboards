#!/bin/bash

# TUI Installer for Myanmar Linux Keyboards
# Provides an interactive menu-driven installation experience

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Emoji definitions
EMOJI_CHECKMARK="✅"
EMOJI_CROSS="❌"
EMOJI_WARNING="⚠️"
EMOJI_INFO="ℹ️"
EMOJI_KEYBOARD="⌨️"
EMOJI_GEAR="⚙️"
EMOJI_ARROW="➡️"

# Function to print colored text
print_color() {
    local color="$1"
    local text="$2"
    echo -e "${color}${text}${NC}"
}

# Function to print header
print_header() {
    clear
    echo "==============================================="
    echo "           Myanmar Linux Keyboards"
    echo "         Text-based User Interface"
    echo "==============================================="
    echo ""
}

# Function to check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        print_color $RED "This script must be run as root (use sudo)"
        exit 1
    fi
}

# Function to check if required packages are installed
check_dependencies() {
    local missing_packages=()
    
    # Check for ibus-table
    if ! command -v ibus-table-createdb &> /dev/null; then
        missing_packages+=("ibus-table")
    fi
    
    # Check for xkb utilities
    if ! command -v setxkbmap &> /dev/null; then
        missing_packages+=("xkb-data")
    fi
    
    if [ ${#missing_packages[@]} -gt 0 ]; then
        print_color $YELLOW "${EMOJI_WARNING} Missing required packages: ${missing_packages[*]}"
        print_color $CYAN "Please install them with:"
        if command -v apt &> /dev/null; then
            print_color $CYAN "  sudo apt install ${missing_packages[*]}"
        elif command -v dnf &> /dev/null; then
            print_color $CYAN "  sudo dnf install ${missing_packages[*]}"
        elif command -v pacman &> /dev/null; then
            print_color $CYAN "  sudo pacman -S ${missing_packages[*]}"
        else
            print_color $CYAN "  (Use your distribution's package manager)"
        fi
        echo ""
        read -p "Press Enter to continue anyway or Ctrl+C to exit..."
    fi
}

# Function to display main menu
show_main_menu() {
    print_header
    echo "Welcome to the Myanmar Linux Keyboards TUI Installer!"
    echo ""
    print_color $CYAN "Select an installation method:"
    echo ""
    echo "  1) XKB Layouts (System-level keyboard layouts)"
    echo "  2) IBus Table (Input method framework)"
    echo "  3) Both XKB and IBus"
    echo "  4) Exit"
    echo ""
    read -p "Enter your choice [1-4]: " main_choice
}

# Function to display language selection menu
show_language_menu() {
    print_header
    echo "Select which languages to install:"
    echo ""
    echo "  1) All languages (Burmese, Mon, Karen, Shan)"
    echo "  2) Specific languages"
    echo "  3) Back to main menu"
    echo ""
    read -p "Enter your choice [1-3]: " lang_choice
}

# Function to display specific language selection
show_specific_languages() {
    print_header
    echo "Select specific languages to install:"
    echo "(Enter number to toggle selection, 0 to confirm)"
    echo ""
    
    # Reset selections
    burmese_selected=false
    mon_selected=false
    karen_selected=false
    shan_selected=false
    
    while true; do
        # Show current selections
        echo "Current selections:"
        if [ "$burmese_selected" = true ]; then
            echo "  [X] 1) Burmese (Myanmar)"
        else
            echo "  [ ] 1) Burmese (Myanmar)"
        fi
        
        if [ "$mon_selected" = true ]; then
            echo "  [X] 2) Mon"
        else
            echo "  [ ] 2) Mon"
        fi
        
        if [ "$karen_selected" = true ]; then
            echo "  [X] 3) Karen (Sgaw, Eastern Pwo, Western Pwo)"
        else
            echo "  [ ] 3) Karen (Sgaw, Eastern Pwo, Western Pwo)"
        fi
        
        if [ "$shan_selected" = true ]; then
            echo "  [X] 4) Shan"
        else
            echo "  [ ] 4) Shan"
        fi
        
        echo ""
        echo "  5) Select All"
        echo "  6) Deselect All"
        echo "  0) Confirm selection and proceed"
        echo ""
        
        read -p "Enter your choice: " specific_choice
        
        case $specific_choice in
            1)
                if [ "$burmese_selected" = true ]; then
                    burmese_selected=false
                    print_color $YELLOW "${EMOJI_WARNING} Deselected Burmese"
                else
                    burmese_selected=true
                    print_color $GREEN "${EMOJI_CHECKMARK} Selected Burmese"
                fi
                ;;
            2)
                if [ "$mon_selected" = true ]; then
                    mon_selected=false
                    print_color $YELLOW "${EMOJI_WARNING} Deselected Mon"
                else
                    mon_selected=true
                    print_color $GREEN "${EMOJI_CHECKMARK} Selected Mon"
                fi
                ;;
            3)
                if [ "$karen_selected" = true ]; then
                    karen_selected=false
                    print_color $YELLOW "${EMOJI_WARNING} Deselected Karen"
                else
                    karen_selected=true
                    print_color $GREEN "${EMOJI_CHECKMARK} Selected Karen"
                fi
                ;;
            4)
                if [ "$shan_selected" = true ]; then
                    shan_selected=false
                    print_color $YELLOW "${EMOJI_WARNING} Deselected Shan"
                else
                    shan_selected=true
                    print_color $GREEN "${EMOJI_CHECKMARK} Selected Shan"
                fi
                ;;
            5)
                burmese_selected=true
                mon_selected=true
                karen_selected=true
                shan_selected=true
                print_color $GREEN "${EMOJI_CHECKMARK} Selected all languages"
                ;;
            6)
                burmese_selected=false
                mon_selected=false
                karen_selected=false
                shan_selected=false
                print_color $YELLOW "${EMOJI_WARNING} Deselected all languages"
                ;;
            0)
                # Check if at least one language is selected
                if [ "$burmese_selected" = false ] && [ "$mon_selected" = false ] && \
                   [ "$karen_selected" = false ] && [ "$shan_selected" = false ]; then
                    print_color $RED "${EMOJI_CROSS} Please select at least one language"
                    continue
                fi
                break
                ;;
            *)
                print_color $RED "${EMOJI_CROSS} Invalid choice"
                ;;
        esac
        
        echo ""
        read -p "Press Enter to continue..."
    done
}

# Function to install XKB layouts
install_xkb_layouts() {
    print_header
    print_color $BLUE "${EMOJI_GEAR} Installing XKB layouts..."
    echo ""
    
    # Change to the installers directory
    cd "$(dirname "$0")"
    
    # Install based on selections
    if [ "$karen_selected" = true ]; then
        if [ -f "xkb/install-karen-xkb.sh" ]; then
            print_color $CYAN "Installing Karen XKB layouts..."
            bash xkb/install-karen-xkb.sh
        else
            print_color $RED "${EMOJI_CROSS} Karen XKB installer not found"
        fi
    fi
    
    if [ "$mon_selected" = true ]; then
        if [ -f "xkb/install-mon-xkb.sh" ]; then
            print_color $CYAN "Installing Mon XKB layouts..."
            bash xkb/install-mon-xkb.sh
        else
            print_color $YELLOW "${EMOJI_WARNING} Mon XKB installer not found (will be available in future releases)"
        fi
    fi
    
    if [ "$shan_selected" = true ]; then
        if [ -f "xkb/install-shan-xkb.sh" ]; then
            print_color $CYAN "Installing Shan XKB layouts..."
            bash xkb/install-shan-xkb.sh
        else
            print_color $YELLOW "${EMOJI_WARNING} Shan XKB installer not found (will be available in future releases)"
        fi
    fi
    
    if [ "$burmese_selected" = true ]; then
        if [ -f "xkb/install-burmese-xkb.sh" ]; then
            print_color $CYAN "Installing Burmese XKB layouts..."
            bash xkb/install-burmese-xkb.sh
        else
            print_color $YELLOW "${EMOJI_WARNING} Burmese XKB installer not found (will be available in future releases)"
        fi
    fi
    
    print_color $GREEN "${EMOJI_CHECKMARK} XKB layout installation completed!"
    echo ""
    read -p "Press Enter to continue..."
}

# Function to install IBus tables
install_ibus_tables() {
    print_header
    print_color $BLUE "${EMOJI_GEAR} Installing IBus tables..."
    echo ""
    
    # Change to the installers directory
    cd "$(dirname "$0")"
    
    # Install based on selections
    if [ "$karen_selected" = true ]; then
        if [ -f "ibus/install-karen-ibus.sh" ]; then
            print_color $CYAN "Installing Karen IBus tables..."
            bash ibus/install-karen-ibus.sh
        else
            print_color $RED "${EMOJI_CROSS} Karen IBus installer not found"
        fi
    fi
    
    if [ "$mon_selected" = true ]; then
        if [ -f "ibus/install-mon-ibus.sh" ]; then
            print_color $CYAN "Installing Mon IBus tables..."
            bash ibus/install-mon-ibus.sh
        else
            print_color $YELLOW "${EMOJI_WARNING} Mon IBus installer not found (will be available in future releases)"
        fi
    fi
    
    if [ "$shan_selected" = true ]; then
        if [ -f "ibus/install-shan-ibus.sh" ]; then
            print_color $CYAN "Installing Shan IBus tables..."
            bash ibus/install-shan-ibus.sh
        else
            print_color $YELLOW "${EMOJI_WARNING} Shan IBus installer not found (will be available in future releases)"
        fi
    fi
    
    if [ "$burmese_selected" = true ]; then
        if [ -f "ibus/install-burmese-ibus.sh" ]; then
            print_color $CYAN "Installing Burmese IBus tables..."
            bash ibus/install-burmese-ibus.sh
        else
            print_color $YELLOW "${EMOJI_WARNING} Burmese IBus installer not found (will be available in future releases)"
        fi
    fi
    
    print_color $GREEN "${EMOJI_CHECKMARK} IBus table installation completed!"
    echo ""
    read -p "Press Enter to continue..."
}

# Function to show installation summary
show_summary() {
    print_header
    print_color $GREEN "${EMOJI_CHECKMARK} Installation Summary"
    echo ""
    
    if [ "$install_xkb" = true ]; then
        print_color $BLUE "${EMOJI_KEYBOARD} XKB Layouts installed:"
        if [ "$burmese_selected" = true ]; then
            echo "  - Burmese (Myanmar)"
        fi
        if [ "$mon_selected" = true ]; then
            echo "  - Mon"
        fi
        if [ "$karen_selected" = true ]; then
            echo "  - Karen (Sgaw, Eastern Pwo, Western Pwo)"
        fi
        if [ "$shan_selected" = true ]; then
            echo "  - Shan"
        fi
        echo ""
    fi
    
    if [ "$install_ibus" = true ]; then
        print_color $BLUE "${EMOJI_KEYBOARD} IBus Tables installed:"
        if [ "$burmese_selected" = true ]; then
            echo "  - Burmese (Myanmar)"
        fi
        if [ "$mon_selected" = true ]; then
            echo "  - Mon"
        fi
        if [ "$karen_selected" = true ]; then
            echo "  - Karen (Sgaw, Eastern Pwo, Western Pwo)"
        fi
        if [ "$shan_selected" = true ]; then
            echo "  - Shan"
        fi
        echo ""
    fi
    
    print_color $CYAN "${EMOJI_INFO} To use the keyboards:"
    echo "  1. Restart your desktop session or reboot"
    echo "  2. Go to System Settings > Region & Language > Input Sources"
    echo "  3. Add the Myanmar keyboards you installed"
    echo ""
    print_color $YELLOW "${EMOJI_WARNING} If keyboards don't appear immediately:"
    echo "  - For XKB: Clear XKB cache with 'sudo rm -f /var/lib/xkb/*.xkm'"
    echo "  - For IBus: Restart IBus with 'ibus restart'"
    echo ""
    print_color $CYAN "${EMOJI_INFO} Switch between input methods:"
    echo "  - GNOME/KDE: Super+Space or Alt+Shift"
    echo "  - XFCE: Configurable in Keyboard Settings"
    echo ""
    read -p "Press Enter to exit..."
}

# Main script execution
main() {
    # Initial checks
    check_root
    check_dependencies
    
    # Initialize variables
    install_xkb=false
    install_ibus=false
    burmese_selected=false
    mon_selected=false
    karen_selected=false
    shan_selected=false
    
    # Main menu loop
    while true; do
        show_main_menu
        
        case $main_choice in
            1)
                install_xkb=true
                install_ibus=false
                break
                ;;
            2)
                install_xkb=false
                install_ibus=true
                break
                ;;
            3)
                install_xkb=true
                install_ibus=true
                break
                ;;
            4)
                print_color $YELLOW "Exiting installer..."
                exit 0
                ;;
            *)
                print_color $RED "${EMOJI_CROSS} Invalid choice. Please select 1-4."
                read -p "Press Enter to continue..."
                ;;
        esac
    done
    
    # Language selection
    while true; do
        show_language_menu
        
        case $lang_choice in
            1)
                # Select all languages
                burmese_selected=true
                mon_selected=true
                karen_selected=true
                shan_selected=true
                break
                ;;
            2)
                # Show specific language selection
                show_specific_languages
                break
                ;;
            3)
                # Go back to main menu
                back_to_main_menu=true
                break
                ;;
            *)
                print_color $RED "${EMOJI_CROSS} Invalid choice. Please select 1-3."
                read -p "Press Enter to continue..."
                ;;
        esac
    done
    
    # Perform installations
    if [ "$install_xkb" = true ]; then
        install_xkb_layouts
    fi
    
    if [ "$install_ibus" = true ]; then
        install_ibus_tables
    fi
    
    # Show summary
    while true; do
        # Reset variables for each run
        install_xkb=false
        install_ibus=false
        burmese_selected=false
        mon_selected=false
        karen_selected=false
        shan_selected=false
        
        # Main menu loop
        while true; do
            show_main_menu
            
            case $main_choice in
                1)
                    install_xkb=true
                    install_ibus=false
                    break
                    ;;
                2)
                    install_xkb=false
                    install_ibus=true
                    break
                    ;;
                3)
                    install_xkb=true
                    install_ibus=true
                    break
                    ;;
                4)
                    print_color $YELLOW "Exiting installer..."
                    exit 0
                    ;;
                *)
                    print_color $RED "${EMOJI_CROSS} Invalid choice. Please select 1-4."
                    read -p "Press Enter to continue..."
                    ;;
            esac
        done
        
        # Language selection
        back_to_main_menu=false
        while true; do
            show_language_menu
            
            case $lang_choice in
                1)
                    # Select all languages
                    burmese_selected=true
                    mon_selected=true
                    karen_selected=true
                    shan_selected=true
                    break
                    ;;
                2)
                    # Show specific language selection
                    show_specific_languages
                    break
                    ;;
                3)
                    # Go back to main menu
                    back_to_main_menu=true
                    break
                    ;;
                *)
                    print_color $RED "${EMOJI_CROSS} Invalid choice. Please select 1-3."
                    read -p "Press Enter to continue..."
                    ;;
            esac
        done
        
        # If user chose to go back to main menu, restart outer loop
        if [ "$back_to_main_menu" = true ]; then
            continue
        fi
        
        # Perform installations
        if [ "$install_xkb" = true ]; then
            install_xkb_layouts
        fi
        
        if [ "$install_ibus" = true ]; then
            install_ibus_tables
        fi
        
        # Show summary
        show_summary
        
        # After summary, exit installer
        break
    done
}

# Run main function
main "$@"