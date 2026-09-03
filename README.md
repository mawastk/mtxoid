![Logo](https://github.com/mawastk/mtxoid/blob/main/image/benner.png?raw=true)
Please note: This text has been translated from Japanese. You can also read the original readme in its original language.<br>

# Mtxoid
MTX Converter for Android

![Screenshot](https://github.com/mawastk/mtxoid/blob/main/image/screenshot.png?raw=true)

# How to install
mtxoid provides an APK that can be installed directly on Android devices.

| Limit | Supported Versions |
|:-----------|:------------:|
| Minimum     | Android 7.0 ~       |

# How do I use it?

The UI is simple and can be controlled with just two buttons; it allows you to convert between PNG and MTX formats.<br>

Since it uses the OS's native file picker, please avoid keeping the file picker open for too long if you have limited RAM (the callback is actually quite shoddy...).

# Supported Types

mtxoid supports importing and exporting PNG files, as well as exporting to MTXv1 with transparency.

| Type | Import | Export |
|:-----------|:------------:|:------------:|
| MTXv0 |✅|❌|
| MTXv1 |✅|✅|
| MTXv2 |❌|❌|
| PNG |✅|✅|

# Does this project use mtxconv?

No, mtxconv is not included.
