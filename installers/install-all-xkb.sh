#!/bin/bash
# Install all Myanmar XKB layouts

echo "⌨️  Installing all Myanmar XKB layouts..."

# Install Karen keyboards
if [ -f "xkb/install-karen-xkb.sh" ]; then
    echo "📝 Installing Karen keyboards..."
    bash xkb/install-karen-xkb.sh
fi

# Add other languages here as they become available
# bash xkb/install-mon-xkb.sh
# bash xkb/install-shan-xkb.sh
# bash xkb/install-burmese-xkb.sh

echo "✅ All XKB layouts installed!"
