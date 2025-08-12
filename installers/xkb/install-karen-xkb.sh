#!/bin/bash

# Unified XKB installer for all Karen keyboard layouts
# Installs Eastern Pwo Karen (kjp), Western Pwo Karen (pwo), and Sgaw Karen (ksw)
# Usage: sudo ./install-xkb.sh

XKB_SYMBOLS_DIR="/usr/share/X11/xkb/symbols"
XKB_RULES_DIR="/usr/share/X11/xkb/rules"
LAYOUT_FILE="mm-karen-layouts"
BACKUP_SUFFIX=".backup.$(date +%Y%m%d_%H%M%S)"

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (use sudo)"
    exit 1
fi

echo "Installing Karen keyboard layouts (kjp, pwo, ksw) under mm (Myanmar)..."

# Check if layout file exists
if [ ! -f "$LAYOUT_FILE" ]; then
    echo "Error: $LAYOUT_FILE not found!"
    echo "Please ensure the Karen layouts file is in the current directory"
    exit 1
fi

# Install the symbols file to mm symbols file
echo "Installing Karen symbols to mm layout..."
MM_SYMBOLS="$XKB_SYMBOLS_DIR/mm"

# Backup existing mm symbols file
if [ -f "$MM_SYMBOLS" ]; then
    cp "$MM_SYMBOLS" "$MM_SYMBOLS$BACKUP_SUFFIX"
    echo "Backed up existing mm symbols file"
fi

# Append Karen layouts to mm symbols file
{
    echo ""
    echo "// Karen keyboard layouts - Eastern Pwo, Western Pwo, Sgaw"
    cat "$LAYOUT_FILE"
} >> "$MM_SYMBOLS"

chmod 644 "$MM_SYMBOLS"

# Update evdev.lst
EVDEV_LST="$XKB_RULES_DIR/evdev.lst"
if [ -f "$EVDEV_LST" ]; then
    echo "Updating evdev.lst..."
    cp "$EVDEV_LST" "$EVDEV_LST$BACKUP_SUFFIX"
    
    # Add Karen variants if not exist
    if ! grep -q "kjp.*mm.*Eastern Pwo Karen" "$EVDEV_LST"; then
        sed -i '/^  zgt.*mm.*Shan (Zawgyi)$/a\  kjp             mm: Eastern Pwo Karen' "$EVDEV_LST"
        echo "Added kjp (Eastern Pwo Karen) variant to evdev.lst"
    fi
    
    if ! grep -q "pwo.*mm.*Western Pwo Karen" "$EVDEV_LST"; then
        sed -i '/^  kjp.*mm.*Eastern Pwo Karen$/a\  pwo             mm: Western Pwo Karen' "$EVDEV_LST"
        echo "Added pwo (Western Pwo Karen) variant to evdev.lst"
    fi
    
    if ! grep -q "ksw.*mm.*Sgaw Karen" "$EVDEV_LST"; then
        sed -i '/^  pwo.*mm.*Western Pwo Karen$/a\  ksw             mm: Sgaw Karen' "$EVDEV_LST"
        echo "Added ksw (Sgaw Karen) variant to evdev.lst"
    fi
fi

# Update evdev.xml
EVDEV_XML="$XKB_RULES_DIR/evdev.xml"
if [ -f "$EVDEV_XML" ]; then
    echo "Updating evdev.xml..."
    cp "$EVDEV_XML" "$EVDEV_XML$BACKUP_SUFFIX"
    
    # Check if Karen variants already exist
    if ! grep -q "<n>kjp</n>" "$EVDEV_XML"; then
        # Create temporary variant blocks for all Karen layouts
        cat >> /tmp/karen_variants.xml << 'EOF'
        <variant>
          <configItem>
            <n>kjp</n>
            <shortDescription>kjp</shortDescription>
            <description>Eastern Pwo Karen</description>
            <languageList>
              <iso639Id>kjp</iso639Id>
            </languageList>
          </configItem>
        </variant>
        <variant>
          <configItem>
            <n>pwo</n>
            <shortDescription>pwo</shortDescription>
            <description>Western Pwo Karen</description>
            <languageList>
              <iso639Id>pwo</iso639Id>
            </languageList>
          </configItem>
        </variant>
        <variant>
          <configItem>
            <n>ksw</n>
            <shortDescription>ksw</shortDescription>
            <description>Sgaw Karen</description>
            <languageList>
              <iso639Id>ksw</iso639Id>
            </languageList>
          </configItem>
        </variant>
EOF
        
        # Insert all Karen variants after the last mm variant
        sed -i '/<description>Shan (Zawgyi)<\/description>/,/<\/variant>/{
            /<\/variant>/r /tmp/karen_variants.xml
        }' "$EVDEV_XML"
        
        # Clean up temp file
        rm -f /tmp/karen_variants.xml
        
        echo "Added all Karen variants to evdev.xml"
    else
        echo "Karen variants already exist in evdev.xml"
    fi
fi

# Clear XKB cache
echo "Clearing XKB cache..."
rm -f /var/lib/xkb/*.xkm 2>/dev/null || true

echo ""
echo "✅ Installation complete!"
echo ""
echo "All Karen keyboard layouts have been installed as variants under mm (Myanmar):"
echo ""
echo "📋 Available layouts:"
echo "  🔸 Eastern Pwo Karen: setxkbmap mm kjp"
echo "  🔸 Western Pwo Karen:  setxkbmap mm pwo"  
echo "  🔸 Sgaw Karen:         setxkbmap mm ksw"
echo ""
echo "🖥️  GUI Installation:"
echo "  1. Restart your desktop session: sudo systemctl restart gdm"
echo "  2. Settings > Region & Language > Input Sources"
echo "  3. Add 'Myanmar' and select the Karen variant you want"
echo ""
echo "⌨️  Switch layouts: Super+Space or Alt+Shift"
echo ""
echo "📖 Character mapping guides available in docs/ directory"
echo ""
echo "🔧 Troubleshooting:"
echo "  - If layouts don't appear, restart your desktop session"
echo "  - Check system logs if there are issues: journalctl -f"
echo "  - Reset to US layout: setxkbmap us"
