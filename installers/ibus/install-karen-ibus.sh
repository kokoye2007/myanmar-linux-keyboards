#!/bin/bash

# Unified ibus-table installer for all Karen keyboard layouts
# Installs Eastern Pwo Karen, Western Pwo Karen, and Sgaw Karen
# Usage: sudo ./install-ibus.sh

TABLES_DIR="/usr/share/ibus-table/tables"
ICONS_DIR="/usr/share/ibus-table/icons"
BACKUP_SUFFIX=".backup.$(date +%Y%m%d_%H%M%S)"

# Karen layouts to install
declare -A KAREN_LAYOUTS=(
    ["eastern-pwo-karen"]="Eastern Pwo Karen"
    ["western-pwo-karen"]="Western Pwo Karen"
    ["sgaw-karen"]="Sgaw Karen"
)

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (use sudo)"
    exit 1
fi

# Check if ibus-table is installed
if ! command -v ibus-table-createdb &> /dev/null; then
    echo "❌ ibus-table is not installed. Please install it first:"
    echo ""
    echo "Ubuntu/Debian: sudo apt install ibus-table"
    echo "Fedora:        sudo dnf install ibus-table"
    echo "Arch:          sudo pacman -S ibus-table"
    echo ""
    exit 1
fi

echo "🔧 Installing Karen ibus-table input methods..."
echo ""

# Create directories
mkdir -p "$TABLES_DIR"
mkdir -p "$ICONS_DIR"

# Install each Karen layout
for layout in "${!KAREN_LAYOUTS[@]}"; do
    TABLE_FILE="${layout}.txt"
    DB_FILE="${layout}.db"
    DESCRIPTION="${KAREN_LAYOUTS[$layout]}"
    
    echo "📝 Processing $DESCRIPTION..."
    
    # Check if table source file exists
    if [ ! -f "$TABLE_FILE" ]; then
        echo "⚠️  Warning: $TABLE_FILE not found, skipping $DESCRIPTION"
        continue
    fi
    
    # Create database from table file
    echo "  🔨 Creating database..."
    if ! ibus-table-createdb -n "$DB_FILE" -s "$TABLE_FILE"; then
        echo "  ❌ Failed to create database for $DESCRIPTION"
        continue
    fi
    
    # Backup existing database if it exists
    if [ -f "$TABLES_DIR/$DB_FILE" ]; then
        cp "$TABLES_DIR/$DB_FILE" "$TABLES_DIR/$DB_FILE$BACKUP_SUFFIX"
        echo "  📋 Backed up existing database"
    fi
    
    # Install database
    cp "$DB_FILE" "$TABLES_DIR/"
    chmod 644 "$TABLES_DIR/$DB_FILE"
    echo "  ✅ Installed $DESCRIPTION database"
done

# Install icons if available
for icon in kawthoolei.svg pwo.svg eastern-pwo.svg; do
    if [ -f "../icons/$icon" ]; then
        cp "../icons/$icon" "$ICONS_DIR/"
        chmod 644 "$ICONS_DIR/$icon"
        echo "🖼️  Installed icon: $icon"
    fi
done

# Use default ibus-table icon if no specific icons found
if [ ! -f "$ICONS_DIR/ibus-table.png" ] && command -v convert &> /dev/null; then
    echo "🎨 Creating default icon..."
    convert -size 48x48 xc:lightblue -font DejaVu-Sans -pointsize 12 \
            -fill black -annotate +8+24 "Karen" "$ICONS_DIR/ibus-table.png" 2>/dev/null || true
fi

# Restart ibus daemon
echo ""
echo "🔄 Restarting ibus..."
if command -v ibus &> /dev/null; then
    # Kill existing ibus processes
    pkill -f ibus-daemon 2>/dev/null || true
    sleep 2
    
    # Start ibus daemon
    ibus-daemon -drx &
    sleep 3
    
    echo "✅ ibus restarted successfully"
else
    echo "⚠️  Warning: ibus command not found. Please restart ibus manually"
fi

echo ""
echo "🎉 Installation complete!"
echo ""
echo "📋 Installed Karen input methods:"
for layout in "${!KAREN_LAYOUTS[@]}"; do
    if [ -f "$TABLES_DIR/${layout}.db" ]; then
        echo "  ✅ ${KAREN_LAYOUTS[$layout]}"
    fi
done
echo ""
echo "🖥️  To activate Karen keyboards:"
echo "  1. Settings > Region & Language > Input Sources"
echo "  2. Click '+' → Other → Select Karen keyboard"
echo "  3. Or use: ibus-setup → Input Method → Add"
echo ""
echo "⌨️  Available input methods:"
echo "  🔸 EasternPwoKaren  - Eastern Pwo Karen (kjp)"
echo "  🔸 WestPwoKaren     - Western Pwo Karen (pwo)"
echo "  🔸 SgawKarenKawthoolei - Sgaw Karen (ksw)"
echo ""
echo "🔄 Switch input methods: Super+Space or your configured hotkey"
echo ""
echo "📖 Character guides:"
echo "  - All layouts follow Windows KLC specifications"
echo "  - Direct one-to-one key mapping (no candidate selection)"
echo "  - Myanmar digits on number keys (1→၁, 2→၂, etc.)"
echo ""
echo "🔧 Troubleshooting:"
echo "  - If keyboards don't appear: ibus restart"
echo "  - Check installation: ibus list-engine | grep -i karen"
echo "  - Debug mode: ibus-daemon -drx"
