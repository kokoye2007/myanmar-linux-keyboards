# Western Pwo Karen (pwo) Keyboards

Western Pwo Karen keyboard layouts and input methods.

## Character Features
- **5-tone system**: ၩ, ၪ, ၫ, ၬ, ၭ
- **Specific consonants**: ၦ (pwa), ၥ (tha), ၧ (eu), ၨ (ue)
- **Special brackets**: Numbers produce [], {}, etc.
- **Myanmar digits**: ၀-၉

## Key Mappings
- R → မ, Shift+R → ၩ (tone-1)
- T → အ, Shift+T → ၪ (tone-2)
- Y → ပ, Shift+Y → ၫ (tone-3)
- A → ၦ (pwa), Shift+A → ၡ (sha)

## Files
- `ibus-table/` - ibus-table input method
- `keymagic/` - KeyMagic layout with ligatures
- `xkb/` - XKB system layout

## Installation
```bash
# XKB layout
setxkbmap mm pwo

# ibus-table
# Add via Settings → Input Sources → Other → WestPwoKaren
```
