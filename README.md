# 🔊 Speaker Replacement (Google Pixel 6a)

![Android](https://img.shields.io/badge/Android-12%2B-3DDC84?style=for-the-badge&logo=android&logoColor=white)
![Target Device](https://img.shields.io/badge/Device-Pixel%206a%20(bluejay)-4285F4?style=for-the-badge&logo=google&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)

A specialized systemless mod for **Google Pixel 6a (`bluejay`)** designed to handle hardware failure of the lower speaker.

---

## 🛠 Features
* **Smart Rerouting:** Automatically routes all media audio, system notifications, alarms, and speakerphone calls to the top earpiece speaker.
* **Hardware Protection:** Completely isolates and powers down the failed bottom amplifier path on the ALSA driver level to prevent overheating and power drain.
* **Systemless Overlay:** Modifies `mixer_paths.xml` on the fly without altering the physical `/system` or `/vendor` partitions.
* **Universal Compatibility:** Works with Magisk, KernelSU, KernelSU Next, and APatch.

---

## 📋 Compatibility
- **Device:** Google Pixel 6a (`bluejay`)
- **Android Versions:** Android 12 (API 31) up to Android 16+
- **Architecture:** `arm64` / `aarch64`

---

## 📥 Installation

1. Download the latest `swapspeakers.zip` from the [Releases](https://github.com/nequb1/Speaker-Replacement/releases) section.
2. Open your preferred Root Manager (Magisk / KernelSU / APatch).
3. Flash the `.zip` archive.
4. Reboot your device.

---

## ⚠️ Safety & Uninstallation
To revert back to original stock audio routing, simply disable or remove the module in your root manager and reboot.
