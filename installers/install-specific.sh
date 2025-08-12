#!/bin/bash
# Install specific language keyboards

LANGUAGE=$1

if [ -z "$LANGUAGE" ]; then
    echo "Usage: $0 <language>"
    echo "Available: burmese, mon, karen, shan"
    exit 1
fi

case $LANGUAGE in
    "karen")
        echo "Installing Karen keyboards..."
        bash xkb/install-karen.sh
        bash ibus/install-karen.sh
        ;;
    "mon")
        echo "Installing Mon keyboards..."
        bash xkb/install-mon.sh
        bash ibus/install-mon.sh
        ;;
    "shan")
        echo "Installing Shan keyboards..."
        bash xkb/install-shan.sh
        bash ibus/install-shan.sh
        ;;
    "burmese")
        echo "Installing Burmese keyboards..."
        bash xkb/install-burmese.sh
        bash ibus/install-burmese.sh
        ;;
    *)
        echo "Unknown language: $LANGUAGE"
        exit 1
        ;;
esac
