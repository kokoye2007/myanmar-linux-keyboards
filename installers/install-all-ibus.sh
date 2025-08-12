#!/bin/bash
# Install all Myanmar ibus-table input methods

echo "🔧 Installing all Myanmar ibus-table input methods..."

# Install Karen keyboards
if [ -f "ibus/install-karen-ibus.sh" ]; then
    echo "📝 Installing Karen keyboards..."
    bash ibus/install-karen-ibus.sh
fi

# Add other languages here as they become available
# bash ibus/install-mon-ibus.sh
# bash ibus/install-shan-ibus.sh
# bash ibus/install-burmese-ibus.sh

echo "✅ All ibus input methods installed!"
