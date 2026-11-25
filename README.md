<div align="center">

# Spinyin-lyric for Spotify

**Real-time offline Mandarin (Hanzi) to Pinyin smart lyrics for Spotify.**

[![Version](https://img.shields.io/badge/version-v1.0.0-1ed760?style=flat-square)](https://github.com/Eugenewijaya/spinyin-lyric/releases)
[![Spicetify](https://img.shields.io/badge/Spicetify-Marketplace%20Ready-1db954?style=flat-square&logo=spotify&logoColor=white)](https://spicetify.app)
[![Offline](https://img.shields.io/badge/engine-100%25%20offline-22262e?style=flat-square)](#features)
[![License](https://img.shields.io/badge/license-MIT-blue?style=flat-square)](LICENSE)

<br/>

<img src="preview.svg" alt="Spinyin-lyric for Spotify live Pinyin preview" width="820"/>

</div>

---

## Quick Install

### Windows (PowerShell — Recommended)

Requires [Spicetify](https://spicetify.app/docs/getting-started) installed. Run this single command in PowerShell:

```powershell
iwr -useb https://raw.githubusercontent.com/Eugenewijaya/spinyin-lyric/main/install.ps1 | iex
```

### Spicetify Marketplace

1. Open Spotify and go to **Marketplace → Extensions**.
2. Search for **Spinyin-lyric for Spotify**.
3. Click **Install** and reload Spotify.

### macOS / Linux

```bash
EXT_DIR="$(dirname "$(spicetify -c)")/Extensions" && mkdir -p "$EXT_DIR" && curl -fsSL https://raw.githubusercontent.com/Eugenewijaya/spinyin-lyric/main/spinyin-lyric.js -o "$EXT_DIR/spinyin-lyric.js" && spicetify config extensions spinyin-lyric.js && spicetify apply
```

---

## Features

- **Real-time running lyrics Pinyin** — automatically displays Pinyin right underneath every Mandarin lyric line and highlights in sync with the active line.
- **100% offline engine** — bundles `pinyin-pro` locally inside `spinyin-lyric.js` for `0ms` conversion with zero external API calls, zero rate limits, and full CSP safety.
- **Accurate Mandarin handling** — supports Simplified (`简体`), Traditional (`繁體`), context-aware polyphones (`音乐` → `yīn yuè`, `银行` → `yín háng`), tone sandhi, and mixed Chinese/English lines.
- **Works across lyrics extensions** — automatically connects to Spotify's native lyrics as well as popular Spicetify lyrics extensions without breaking React rendering or karaoke animations.
- **On-screen floating pill** — subtle glass control pill (`拼 Spinyin ON · nǐ hǎo`) appears only while Chinese lyrics are visible, letting you toggle ON/OFF or cycle tone formats in one click.
- **Spinyin Studio modal** — click the `拼` icon on the Spotify playbar (or **Profile Menu → Spinyin-lyric**) to configure scopes, inspect the current track, or paste any Mandarin text for ruby-annotated Pinyin and one-click copy.
- **Lightweight & motion-aware** — bounded memory cache, debounced DOM observer, pauses idle sweeps when hidden, and respects `prefers-reduced-motion`.

---

## Compatibility

| Lyrics Engine / Platform | Supported | Notes |
| --- | :---: | --- |
| Spotify Native Lyrics (Fullscreen, Cinema, Now Playing Card, Track Page) | Yes | Syncs with active & passed line states |
| Liquid Lyrics (`NMWplays/Liquid-Lyrics`) | Yes | Supports running lines & left song card; skips duplicate romanization |
| Beautiful Lyrics (`surfbryce/beautiful-lyrics`) | Yes | Flex-safe Pinyin line below lead & background vocals |
| Spicy Lyrics (`Spikerko/spicy-lyrics`) | Yes | Works with synced line views |
| Lyrics Plus (Spicetify Built-in) | Yes | Works alongside native Lyrics Plus views |
| Windows / macOS / Linux (Spotify 1.2.x & 1.3.x+) | Yes | Tested on Spotify `1.3.10+` & Spicetify `v2.46.7` |

---

## Tone Formats

Switch anytime via the floating pill, Playbar Studio modal, or Profile menu:

| Style | Example (`月亮代表我的心`) |
| --- | --- |
| **Tone Marks** *(default)* | `yuè liàng dài biǎo wǒ de xīn` |
| **Tone Numbers** | `yue4 liang4 dai4 biao3 wo3 de0 xin1` |
| **Plain** | `yue liang dai biao wo de xin` |

---

## Update & Uninstall

**Update (Windows PowerShell):** re-run the install command above.

**Uninstall (Windows PowerShell):**

```powershell
$env:SPINYIN_UNINSTALL="1"; iwr -useb https://raw.githubusercontent.com/Eugenewijaya/spinyin-lyric/main/install.ps1 | iex; Remove-Item Env:SPINYIN_UNINSTALL
```

---

## Versioning & Changelog

This project follows [Semantic Versioning](https://semver.org/).

### `v1.0.0` (Initial Open-Source Release)
- Bundled offline `pinyin-pro@3.28.1` engine with UMD isolation.
- Universal smart lyrics support (Spotify Native, Liquid Lyrics, Beautiful Lyrics, Spicy Lyrics, Lyrics Plus).
- Auto-Pinyin for song titles, albums, and artists across Spotify 1.3.x layouts.
- Floating smart lyrics pill, Spinyin Studio modal with Ruby preview, and refined CSS transitions.
- One-line PowerShell installer (`install.ps1`) and Spicetify Marketplace manifest (`manifest.json`).

---

## Support the Developer

If **Spinyin-lyric for Spotify** makes listening to Mandarin music more enjoyable, you can support ongoing maintenance and updates:

- **Star this repository** on GitHub so more listeners can discover it: [Eugenewijaya/spinyin-lyric](https://github.com/Eugenewijaya/spinyin-lyric)
- **Sponsor the developer**: [github.com/sponsors/Eugenewijaya](https://github.com/sponsors/Eugenewijaya)
- **Report a bug or suggest a feature**: [Open an Issue](https://github.com/Eugenewijaya/spinyin-lyric/issues)
- **Contribute**: Pull requests are always welcome.

<div align="center">
<sub>Built with care by <a href="https://github.com/Eugenewijaya">@Eugenewijaya</a> · Powered by <a href="https://github.com/zh-lx/pinyin-pro">pinyin-pro</a> · Released under the <a href="LICENSE">MIT License</a></sub>
</div>
