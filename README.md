# Myanmar Linux Keyboards

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub release](https://img.shields.io/github/release/kokoye2007/myanmar-linux-keyboards.svg)](https://github.com/kokoye2007/myanmar-linux-keyboards/releases)
[![GitHub issues](https://img.shields.io/github/issues/kokoye2007/myanmar-linux-keyboards.svg)](https://github.com/kokoye2007/myanmar-linux-keyboards/issues)
[![GitHub stars](https://img.shields.io/github/stars/kokoye2007/myanmar-linux-keyboards.svg)](https://github.com/kokoye2007/myanmar-linux-keyboards/stargazers)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04%2B-orange.svg)](https://ubuntu.com/)
[![Fedora](https://img.shields.io/badge/Fedora-35%2B-blue.svg)](https://getfedora.org/)
[![Arch](https://img.shields.io/badge/Arch-rolling-brightgreen.svg)](https://archlinux.org/)

Complete keyboard layout package for Myanmar scripts on Linux systems. Supporting all major Myanmar languages with multiple input methods.

## 🌏 Languages Supported

| Language | ISO Code | Script | Status | Keyboards |
|----------|----------|---------|---------|-----------|
| 🇲🇲 **Burmese** (Myanmar) | `my` | Myanmar | ✅ Complete | Standard, Zawgyi |
| 📜 **Mon** | `mnw` | Myanmar | ✅ Complete | Standard, A1 |
| 🏔️ **Shan** | `shn` | Myanmar | ✅ Complete | Standard, Zawgyi |
| 🌾 **Karen (Sgaw)** | `ksw` | Myanmar | ✅ Complete | Kawthoolei |
| 🌾 **Karen (Eastern Pwo)** | `kjp` | Myanmar | ✅ Complete | Unicode |
| 🌾 **Karen (Western Pwo)** | `pwo` | Myanmar | ✅ Complete | Kawthoolei |
| 🏔️ **Kayah** | `kyu` | Myanmar | 🚧 Planned | - |

## 🚀 Quick Installation

### Install All Keyboards
```bash
# Clone repository
git clone https://github.com/kokoye2007/myanmar-linux-keyboards.git
cd myanmar-linux-keyboards

# Install all XKB layouts (system-level)
sudo ./installers/install-all-xkb.sh

# Install all ibus-table input methods
sudo ./installers/install-all-ibus.sh
```

### Install Specific Language
```bash
# Install only Karen keyboards
sudo ./installers/install-specific.sh karen

# Install only Mon keyboards  
sudo ./installers/install-specific.sh mon

# Install only Shan keyboards
sudo ./installers/install-specific.sh shan
```

### Interactive TUI Installer
For a guided installation experience, use our Text-based User Interface installer:
```bash
# Run the interactive TUI installer
sudo ./installers/tui-installer.sh
```
The TUI installer provides an easy-to-use menu system that allows you to:
- Choose between XKB layouts, IBus tables, or both
- Select specific languages to install
- Get real-time feedback during installation

## ⌨️ Input Methods Available

### **XKB Layouts** (System-level)
- Integrates with desktop environment
- Works across all applications
- Standard Linux keyboard layout system
- Usage: `setxkbmap mm <variant>`

### **ibus-table** (Input Method)
- Direct character mapping
- No candidate selection needed
- Windows KLC compatible behavior
- Usage: Add via Settings → Input Sources

### **KeyMagic** (Advanced)
- Automatic ligature generation
- Smart character corrections
- Context-aware input
- Usage: Install KeyMagic + load .kms files

## 🎯 Character Access Examples

### Common Patterns (All Languages)
```
Numbers: 1-9,0 → ၁-၉,၀ (Myanmar digits)
Basic:   q,w,e,r,t → ဆ,တ,န,မ,အ (consonants)
Vowels:  d,g,k,l → ိ,ါ,ု,ူ (vowel signs)
Marks:   f,h,j → ်,့,ြ (diacritics)
```

### Language-Specific Characters

**Karen (Eastern Pwo)**:
```
P → စ, Shift+P → ၮ (nna)
[ → ဟ, Shift+[ → ၯ (ywa)  
] → ☆, Shift+] → ၰ (ghwa)
```

**Karen (Western Pwo)**:
```
R → မ, Shift+R → ၩ (tone-1)
T → အ, Shift+T → ၪ (tone-2)
A → ၦ (pwa), Shift+A → ၡ (sha)
```

**Karen (Sgaw)**:
```
Q → ဆ, Shift+Q → ၡ (sha)
E → န, Shift+E → ၢ (eu)
R → မ, Shift+R → ၤ (kepho)
```

**Mon**:
```
I → ၚ (mon nga)
B → ၜ (mon bba)
```

**Shan**:
```
U → ၥ (shan tone)
Specific Shan characters and tone marks
```

## 📱 Desktop Integration

### GNOME
1. Settings → Region & Language → Input Sources
2. Click "+" → Other → Select Myanmar script
3. Choose your language variant
4. Switch: **Super + Space**

### KDE Plasma
1. System Settings → Input Devices → Keyboard → Layouts
2. Add → Myanmar → Select variant
3. Switch: **Alt + Shift**

### XFCE
1. Settings → Keyboard → Layout
2. Add → Myanmar → Select variant
3. Configure switching hotkey

## 🛠️ Development

### Building from Source
```bash
# Generate XKB layouts
cd scripts/
./build-xkb.sh

# Generate ibus-table files
./build-ibus.sh

# Test layouts
./test-layouts.sh
```

### Contributing
1. **Fork** the repository
2. **Create** feature branch: `git checkout -b feature/new-language`
3. **Commit** changes: `git commit -am 'Add new language support'`
4. **Push** branch: `git push origin feature/new-language`
5. **Submit** Pull Request

### Adding New Languages
1. Create language directory in `scripts/`
2. Add XKB symbols file
3. Create ibus-table definition
4. Add KeyMagic script (optional)
5. Update installers and documentation

## 📋 System Requirements

### Supported Distributions
- **Ubuntu** 20.04+ / **Debian** 11+
- **Fedora** 35+ / **CentOS** 8+
- **Arch Linux** / **Manjaro**
- **openSUSE** Leap 15.3+

### Required Packages
```bash
# Ubuntu/Debian
sudo apt install xkb-data ibus-table

# Fedora
sudo dnf install xkeyboard-config ibus-table

# Arch Linux
sudo pacman -S xkeyboard-config ibus-table
```

### Recommended Fonts
```bash
# Install Myanmar Unicode fonts
sudo apt install fonts-noto-myanmar fonts-myanmar  # Ubuntu
sudo dnf install google-noto-sans-myanmar-fonts    # Fedora
sudo pacman -S noto-fonts                          # Arch
```

## 🐛 Troubleshooting

### XKB Issues
```bash
# Check current layout
setxkbmap -query

# Reset to US layout
setxkbmap us

# Clear XKB cache
sudo rm -f /var/lib/xkb/*.xkm

# Restart display manager
sudo systemctl restart gdm  # or sddm/lightdm
```

### ibus Issues
```bash
# Restart ibus
ibus restart

# Check available engines
ibus list-engine | grep myanmar

# Debug mode
ibus-daemon -drx
```

### Character Display Problems
1. Install Myanmar Unicode fonts
2. Check system language support
3. Verify font fallback configuration
4. Test with different applications

## 📚 Documentation

- **[Installation Guide](docs/installation.md)** - Detailed setup instructions
- **[Character Maps](docs/character-maps.md)** - Complete character reference
- **[User Guide](docs/user-guide.md)** - How to use each input method
- **[Developer Guide](docs/developer-guide.md)** - Contributing and building
- **[Troubleshooting](docs/troubleshooting.md)** - Common issues and solutions

## 🤝 Community

### Communication
- **Issues**: Bug reports and feature requests
- **Discussions**: General questions and ideas
- **Wiki**: Community documentation
- **Releases**: Stable versions and changelogs

### Contributors
- Language experts and native speakers
- Linux distribution maintainers
- Unicode and typography specialists
- Community translators

### Acknowledgments
- **Myanmar Unicode Initiative** - Standardization efforts
- **KNU (Karen National Union)** - Karen layout specifications
- **Mon Language Project** - Mon script expertise
- **Shan Digital Heritage** - Shan keyboard layouts
- **Linux Internationalization Community** - Technical foundation

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

### Font Licenses
Recommended fonts have their own licenses:
- **Noto Sans Myanmar**: SIL Open Font License
- **Myanmar3**: Custom license
- **Padauk**: SIL Open Font License

## 🌟 Star History

[![Star History Chart](https://api.star-history.com/svg?repos=kokoye2007/myanmar-linux-keyboards&type=Date)](https://star-history.com/#kokoye2007/myanmar-linux-keyboards&Date)

---

**Made with ❤️ for the Myanmar digital community**

*Supporting linguistic diversity and digital inclusion across all Myanmar languages.*
