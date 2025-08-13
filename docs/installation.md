# Installation Guide

Detailed installation instructions for Myanmar Linux Keyboards.

## System Requirements

### Supported Distributions
- **Ubuntu** 20.04+ / **Debian** 11+
- **Fedora** 35+ / **CentOS** 8+
- **Arch Linux** / **Manjaro**
- **openSUSE** Leap 15.3+

### Required Packages
Before installing the keyboards, ensure you have the required packages:

```bash
# Ubuntu/Debian
sudo apt install xkb-data ibus-table

# Fedora
sudo dnf install xkeyboard-config ibus-table

# Arch Linux
sudo pacman -S xkeyboard-config ibus-table

# openSUSE
sudo zypper install xkeyboard-config ibus-table
```

### Recommended Fonts
For proper display of Myanmar characters, install Unicode-compliant fonts:

```bash
# Ubuntu/Debian
sudo apt install fonts-noto-myanmar fonts-myanmar

# Fedora
sudo dnf install google-noto-sans-myanmar-fonts

# Arch Linux
sudo pacman -S noto-fonts

# openSUSE
sudo zypper install google-noto-sans-myanmar-fonts
```

## Installation Methods

### Method 1: Install All Keyboards
To install all available keyboards for both XKB and IBus:

```bash
# Clone repository
git clone https://github.com/kokoye2007/myanmar-linux-keyboards.git
cd myanmar-linux-keyboards

# Install all XKB layouts (system-level)
sudo ./installers/install-all-xkb.sh

# Install all ibus-table input methods
sudo ./installers/install-all-ibus.sh
```

### Method 2: Install Specific Languages
To install keyboards for specific languages:

```bash
# Install only Karen keyboards
sudo ./installers/install-specific.sh karen

# Install only Mon keyboards  
sudo ./installers/install-specific.sh mon

# Install only Shan keyboards
sudo ./installers/install-specific.sh shan

# Install only Burmese keyboards
sudo ./installers/install-specific.sh burmese
```

### Method 3: Interactive TUI Installer
For a guided installation experience, use our Text-based User Interface installer:

```bash
# Run the interactive TUI installer
sudo ./installers/tui-installer.sh
```

The TUI installer provides an easy-to-use menu system that allows you to:
- Choose between XKB layouts, IBus tables, or both
- Select specific languages to install
- Get real-time feedback during installation

#### Using the TUI Installer
1. Run the installer with `sudo ./installers/tui-installer.sh`
2. Select your preferred installation method (XKB, IBus, or both)
3. Choose which languages to install (all or specific ones)
4. Follow the on-screen instructions
5. Restart your desktop session when prompted

### Method 4: Manual Installation
For advanced users who want to manually install specific components:

#### XKB Layouts
```bash
# Navigate to the XKB installer directory
cd installers/xkb

# Install specific language layouts
sudo ./install-karen-xkb.sh
```

#### IBus Tables
```bash
# Navigate to the IBus installer directory
cd installers/ibus

# Install specific language tables
sudo ./install-karen-ibus.sh
```

## Distribution-Specific Instructions

### Ubuntu/Debian
```bash
# Install dependencies
sudo apt update
sudo apt install git xkb-data ibus-table fonts-noto-myanmar

# Clone and install
git clone https://github.com/kokoye2007/myanmar-linux-keyboards.git
cd myanmar-linux-keyboards
sudo ./installers/install-all-xkb.sh
sudo ./installers/install-all-ibus.sh
```

### Fedora
```bash
# Install dependencies
sudo dnf install git xkeyboard-config ibus-table google-noto-sans-myanmar-fonts

# Clone and install
git clone https://github.com/kokoye2007/myanmar-linux-keyboards.git
cd myanmar-linux-keyboards
sudo ./installers/install-all-xkb.sh
sudo ./installers/install-all-ibus.sh
```

### Arch Linux
```bash
# Install dependencies
sudo pacman -S git xkeyboard-config ibus-table noto-fonts

# Clone and install
git clone https://github.com/kokoye2007/myanmar-linux-keyboards.git
cd myanmar-linux-keyboards
sudo ./installers/install-all-xkb.sh
sudo ./installers/install-all-ibus.sh
```

## Post-Installation Setup

### Enabling Keyboards in GNOME
1. Open Settings → Region & Language
2. Click the "+" button under Input Sources
3. Select "Other" and find the Myanmar keyboards
4. Add the keyboards you want to use
5. Switch between keyboards using Super+Space

### Enabling Keyboards in KDE Plasma
1. Open System Settings → Input Devices → Keyboard → Layouts
2. Click "Add" and select Myanmar layouts
3. Apply the changes
4. Switch between layouts using Alt+Shift

### Testing the Installation
To verify that the keyboards are installed correctly:

```bash
# For XKB layouts
setxkbmap -query
setxkbmap mm kjp  # Test Karen Eastern Pwo layout

# For IBus
ibus list-engine | grep -i myanmar
```

## Troubleshooting Installation Issues

### Common Issues and Solutions

#### Issue: Keyboards don't appear in input settings
**Solution**: Restart your desktop session or reboot your system.

#### Issue: IBus engines not found
**Solution**: Restart the IBus daemon:
```bash
ibus restart
```

#### Issue: XKB layouts not working
**Solution**: Clear the XKB cache:
```bash
sudo rm -f /var/lib/xkb/*.xkm
```

#### Issue: Characters not displaying correctly
**Solution**: 
1. Ensure you have installed Myanmar Unicode fonts
2. Check your system's font settings
3. Try different applications to isolate the issue

#### Issue: Permission denied during installation
**Solution**: Ensure you're running the installer with sudo:
```bash
sudo ./installers/tui-installer.sh
```

### Getting Help
If you continue to experience issues:
1. Check the [Troubleshooting Guide](troubleshooting.md)
2. Open an issue on GitHub with details about your system and the error
3. Include the output of `ibus version` and `setxkbmap -query` in your report